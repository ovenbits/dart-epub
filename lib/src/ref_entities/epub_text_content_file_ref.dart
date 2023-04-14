import 'dart:async';

import 'epub_content_file_ref.dart';

class EpubTextContentFileRef extends EpubContentFileRef {
  EpubTextContentFileRef({
    required super.epubBookRef,
    required super.fileName,
    required super.contentType,
    required super.contentMimeType,
  });

  Future<String> ReadContentAsync() async {
    return readContentAsText();
  }
}
