import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubChapter {
  EpubChapter({
    required this.title,
    required this.contentFileName,
    required this.anchor,
    required this.htmlContent,
    required this.subChapters,
  });

  factory EpubChapter.empty() => EpubChapter(
        title: '',
        contentFileName: '',
        anchor: null,
        htmlContent: '',
        subChapters: [],
      );

  String title;
  String contentFileName;
  String? anchor;
  String htmlContent;
  List<EpubChapter> subChapters;

  @override
  int get hashCode {
    var objects = [
      title.hashCode,
      contentFileName.hashCode,
      anchor.hashCode,
      htmlContent.hashCode,
      ...subChapters.map((subChapter) => subChapter.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubChapter?;
    if (otherAs == null) {
      return false;
    }
    return title == otherAs.title && contentFileName == otherAs.contentFileName && anchor == otherAs.anchor && htmlContent == otherAs.htmlContent && collections.listsEqual(subChapters, otherAs.subChapters);
  }

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters.length}';
  }
}
