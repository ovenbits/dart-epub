import 'dart:async';

import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  EpubChapterRef({
    required this.epubTextContentFileRef,
    required this.title,
    required this.contentFileName,
    required this.anchor,
    required this.subChapters,
  });

  EpubTextContentFileRef epubTextContentFileRef;
  String title;
  String contentFileName;
  String? anchor;
  List<EpubChapterRef> subChapters;

  @override
  int get hashCode {
    final objects = [
      title.hashCode,
      contentFileName.hashCode,
      anchor.hashCode,
      epubTextContentFileRef.hashCode,
      ...subChapters.map((subChapter) => subChapter.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubChapterRef?;
    if (otherAs == null) {
      return false;
    }
    return title == otherAs.title && contentFileName == otherAs.contentFileName && anchor == otherAs.anchor && epubTextContentFileRef == otherAs.epubTextContentFileRef && collections.listsEqual(subChapters, otherAs.subChapters);
  }

  Future<String> readHtmlContent() async {
    return epubTextContentFileRef.readContentAsText();
  }

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters.length}';
  }
}
