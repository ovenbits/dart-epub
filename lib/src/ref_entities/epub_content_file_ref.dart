import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:quiver/core.dart';

import '../entities/epub_content_type.dart';
import '../utils/zip_path_utils.dart';
import 'epub_book_ref.dart';

abstract class EpubContentFileRef {
  EpubContentFileRef({
    required this.epubBookRef,
    required this.fileName,
    required this.contentType,
    required this.contentMimeType,
  });

  EpubBookRef epubBookRef;
  String fileName;
  EpubContentType contentType;
  String contentMimeType;

  @override
  int get hashCode => hash3(fileName.hashCode, contentMimeType.hashCode, contentType.hashCode);

  @override
  bool operator ==(other) {
    return (other is EpubContentFileRef && other.fileName == fileName && other.contentMimeType == contentMimeType && other.contentType == contentType);
  }

  ArchiveFile getContentFileEntry() {
    final contentFilePath = ZipPathUtils.combine(epubBookRef.schema.contentDirectoryPath, fileName);
    final contentFileEntry = epubBookRef.epubArchive.files.firstWhereOrNull((ArchiveFile x) => x.name == contentFilePath);
    if (contentFileEntry == null) {
      throw Exception('EPUB parsing error: file $contentFilePath not found in archive.');
    }
    return contentFileEntry;
  }

  List<int> getContentStream() {
    return openContentStream(getContentFileEntry());
  }

  List<int> openContentStream(ArchiveFile contentFileEntry) {
    List<int> contentStream = [];
    if (contentFileEntry.content == null) {
      throw Exception('Incorrect EPUB file: content file \"$fileName\" specified in manifest is not found.');
    }
    contentStream.addAll(contentFileEntry.content);
    return contentStream;
  }

  Future<List<int>> readContentAsBytes() async {
    final contentFileEntry = getContentFileEntry();
    var content = openContentStream(contentFileEntry);
    return content;
  }

  Future<String> readContentAsText() async {
    List<int> contentStream = getContentStream();
    return convert.utf8.decode(contentStream);
  }
}
