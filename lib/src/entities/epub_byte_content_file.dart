import 'package:epub/epub.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubByteContentFile extends EpubContentFile {
  EpubByteContentFile({
    required this.content,
    required super.fileName,
    required super.contentType,
    required super.contentMimeType,
  });

  List<int> content;

  @override
  int get hashCode {
    var objects = [
      contentMimeType.hashCode,
      contentType.hashCode,
      fileName.hashCode,
      ...content.map((content) => content.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubByteContentFile?;
    if (otherAs == null) {
      return false;
    }
    return collections.listsEqual(content, otherAs.content) && contentMimeType == otherAs.contentMimeType && contentType == otherAs.contentType && fileName == otherAs.fileName;
  }
}
