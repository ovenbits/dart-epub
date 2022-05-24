import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:archive/archive.dart';
import 'package:epub/src/readers/content_reader.dart';

import 'entities/epub_book.dart';
import 'entities/epub_byte_content_file.dart';
import 'entities/epub_chapter.dart';
import 'entities/epub_content.dart';
import 'entities/epub_content_file.dart';
import 'entities/epub_text_content_file.dart';
import 'readers/schema_reader.dart';
import 'ref_entities/epub_book_ref.dart';
import 'ref_entities/epub_byte_content_file_ref.dart';
import 'ref_entities/epub_chapter_ref.dart';
import 'ref_entities/epub_content_file_ref.dart';
import 'ref_entities/epub_content_ref.dart';
import 'ref_entities/epub_text_content_file_ref.dart';

class EpubReader {
  /// Opens the book asynchronously without reading its content. Holds the handle to the EPUB file.
  static Future<EpubBookRef> openBook(List<int> bytes) async {
    final epubArchive = ZipDecoder().decodeBytes(bytes);
    final schema = await SchemaReader.readSchema(epubArchive);
    final title = schema.package.metadata.titles.firstOrNull ?? '';
    final authorList = schema.package.metadata.creators.map((creator) => creator.creator).toList();
    final author = authorList.join(', ');

    var bookRef = EpubBookRef(
      epubArchive: epubArchive,
      title: title,
      author: author,
      authorList: authorList,
      schema: schema,
      content: EpubContentRef(html: {}, css: {}, images: {}, fonts: {}, allFiles: {}),
    );

    final content = ContentReader.parseContentMap(bookRef);

    return bookRef.copyWith(content: content);
  }

  /// Opens the book asynchronously and reads all of its content into the memory. Does not hold the handle to the EPUB file.
  static Future<EpubBook> readBook(List<int> bytes) async {
    final epubBookRef = await openBook(bytes);
    List<EpubChapterRef> chapterRefs = epubBookRef.getChapters();

    final result = EpubBook(
      title: epubBookRef.title,
      schema: epubBookRef.schema,
      authorList: epubBookRef.authorList,
      author: epubBookRef.author,
      content: await readContent(epubBookRef.content),
      coverImage: await epubBookRef.readCover(),
      chapters: await readChapters(chapterRefs),
    );

    return result;
  }

  static Future<EpubContent> readContent(EpubContentRef contentRef) async {
    final html = await readTextContentFiles(contentRef.html);
    final css = await readTextContentFiles(contentRef.css);
    final images = await readByteContentFiles(contentRef.images);
    final fonts = await readByteContentFiles(contentRef.fonts);
    Map<String, EpubContentFile> allFiles = {};

    html.forEach((String key, EpubTextContentFile value) {
      allFiles[key] = value;
    });

    css.forEach((String key, EpubTextContentFile value) {
      allFiles[key] = value;
    });

    images.forEach((String key, EpubByteContentFile value) {
      allFiles[key] = value;
    });

    fonts.forEach((String key, EpubByteContentFile value) {
      allFiles[key] = value;
    });

    await Future.forEach(contentRef.allFiles.keys, (String key) async {
      if (!allFiles.containsKey(key)) {
        allFiles[key] = await readByteContentFile(contentRef.allFiles[key]!);
      }
    });

    return EpubContent(
      html: html,
      css: css,
      images: images,
      fonts: fonts,
      allFiles: allFiles,
    );
  }

  static Future<Map<String, EpubTextContentFile>> readTextContentFiles(Map<String, EpubTextContentFileRef> textContentFileRefs) async {
    Map<String, EpubTextContentFile> result = {};

    await Future.forEach(textContentFileRefs.keys, (String key) async {
      EpubContentFileRef value = textContentFileRefs[key]!;
      result[key] = EpubTextContentFile(
        fileName: value.fileName,
        contentType: value.contentType,
        contentMimeType: value.contentMimeType,
        content: await value.readContentAsText(),
      );
    });
    return result;
  }

  static Future<Map<String, EpubByteContentFile>> readByteContentFiles(Map<String, EpubByteContentFileRef> byteContentFileRefs) async {
    Map<String, EpubByteContentFile> result = {};
    await Future.forEach(byteContentFileRefs.keys, (String key) async {
      result[key] = await readByteContentFile(byteContentFileRefs[key]!);
    });
    return result;
  }

  static Future<EpubByteContentFile> readByteContentFile(EpubContentFileRef contentFileRef) async {
    return EpubByteContentFile(
      fileName: contentFileRef.fileName,
      contentType: contentFileRef.contentType,
      contentMimeType: contentFileRef.contentMimeType,
      content: await contentFileRef.readContentAsBytes(),
    );
  }

  static Future<List<EpubChapter>> readChapters(List<EpubChapterRef> chapterRefs) async {
    List<EpubChapter> result = [];
    await Future.forEach(chapterRefs, (EpubChapterRef chapterRef) async {
      final chapter = EpubChapter(
        title: chapterRef.title,
        contentFileName: chapterRef.contentFileName,
        anchor: chapterRef.anchor,
        htmlContent: await chapterRef.readHtmlContent(),
        subChapters: await readChapters(chapterRef.subChapters),
      );

      result.add(chapter);
    });
    return result;
  }
}
