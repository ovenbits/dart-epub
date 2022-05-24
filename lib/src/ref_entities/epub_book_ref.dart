import 'dart:async';

import 'package:archive/archive.dart';
import 'package:image/image.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import '../entities/epub_schema.dart';
import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart';
import 'epub_chapter_ref.dart';
import 'epub_content_ref.dart';

class EpubBookRef {
  final Archive _epubArchive;

  String title;
  String author;
  List<String> authorList;
  EpubSchema schema;
  EpubContentRef content;

  EpubBookRef({
    required Archive epubArchive,
    required this.title,
    required this.author,
    required this.authorList,
    required this.schema,
    required this.content,
  }) : _epubArchive = epubArchive;

  EpubBookRef copyWith({
    Archive? epubArchive,
    String? title,
    String? author,
    List<String>? authorList,
    EpubSchema? schema,
    EpubContentRef? content,
  }) =>
      EpubBookRef(
        epubArchive: epubArchive ?? this.epubArchive,
        title: title ?? this.title,
        author: author ?? this.author,
        authorList: authorList ?? this.authorList,
        schema: schema ?? this.schema,
        content: content ?? this.content,
      );

  @override
  int get hashCode {
    var objects = [
      title.hashCode,
      author.hashCode,
      schema.hashCode,
      content.hashCode,
      ...authorList.map((author) => author.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubBookRef?;
    if (otherAs == null) {
      return false;
    }
    return title == otherAs.title && author == otherAs.author && schema == otherAs.schema && content == otherAs.content && collections.listsEqual(authorList, otherAs.authorList);
  }

  Archive get epubArchive => _epubArchive;

  List<EpubChapterRef> getChapters() => ChapterReader.getChapters(this);

  Future<Image?> readCover() => BookCoverReader.readBookCover(this);
}
