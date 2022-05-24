import 'package:quiver/core.dart';

import 'epub_content_type.dart';

abstract class EpubContentFile {
  EpubContentFile({
    required this.fileName,
    required this.contentType,
    required this.contentMimeType,
  });

  String fileName;
  EpubContentType contentType;
  String contentMimeType;

  @override
  int get hashCode => hash3(fileName.hashCode, contentType.hashCode, contentMimeType.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubContentFile?;
    if (otherAs == null) {
      return false;
    }
    return fileName == otherAs.fileName && contentType == otherAs.contentType && contentMimeType == otherAs.contentMimeType;
  }
}
