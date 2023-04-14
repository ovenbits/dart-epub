import 'package:epub/epub.dart';
import 'package:quiver/core.dart';

class EpubTextContentFile extends EpubContentFile {
  EpubTextContentFile({
    required this.content,
    required super.fileName,
    required super.contentType,
    required super.contentMimeType,
  });

  String content;

  @override
  int get hashCode => hash4(content, contentMimeType, contentType, fileName);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubTextContentFile?;
    if (otherAs == null) {
      return false;
    }
    return content == otherAs.content && contentMimeType == otherAs.contentMimeType && contentType == otherAs.contentType && fileName == otherAs.fileName;
  }
}
