import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';

class EpubBook {
  EpubBook({
    required this.title,
    required this.author,
    required this.authorList,
    required this.schema,
    required this.content,
    this.coverImage,
    required this.chapters,
  });

  String title;
  String author;
  List<String> authorList;
  EpubSchema schema;
  EpubContent content;
  Image? coverImage;
  List<EpubChapter> chapters;

  @override
  int get hashCode {
    var objects = [
      title.hashCode,
      author.hashCode,
      schema.hashCode,
      content.hashCode,
      ...coverImage?.getBytes().map((byte) => byte.hashCode) ?? [0],
      ...authorList.map((author) => author.hashCode),
      ...chapters.map((chapter) => chapter.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubBook?;
    if (otherAs == null) {
      return false;
    }

    return title == otherAs.title && author == otherAs.author && collections.listsEqual(authorList, otherAs.authorList) && schema == otherAs.schema && content == otherAs.content && collections.listsEqual(coverImage?.getBytes(), otherAs.coverImage?.getBytes()) && collections.listsEqual(chapters, otherAs.chapters);
  }
}
