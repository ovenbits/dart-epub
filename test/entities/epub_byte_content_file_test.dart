library epubreadertest;

import 'package:epub/epub.dart';
import 'package:test/test.dart';

main() async {
  var reference = EpubByteContentFile(
    content: [0, 1, 2, 3],
    contentMimeType: "application/test",
    contentType: EpubContentType.OTHER,
    fileName: "orthrosFile",
  );

  EpubByteContentFile? testFile;

  setUp(() async {
    testFile = EpubByteContentFile(
      content: [0, 1, 2, 3],
      contentMimeType: "application/test",
      contentType: EpubContentType.OTHER,
      fileName: "orthrosFile",
    );
  });

  tearDown(() async {
    testFile = null;
  });

  group("EpubByteContentFile", () {
    test(".equals is true for equivalent objects", () async {
      expect(testFile, equals(reference));
    });

    test(".equals is false when Content changes", () async {
      testFile?.content = [3, 2, 1, 0];
      expect(testFile, isNot(reference));
    });

    test(".equals is false when ContentMimeType changes", () async {
      testFile?.contentMimeType = "application/different";
      expect(testFile, isNot(reference));
    });

    test(".equals is false when ContentType changes", () async {
      testFile?.contentType = EpubContentType.CSS;
      expect(testFile, isNot(reference));
    });

    test(".equals is false when FileName changes", () async {
      testFile?.fileName = "a_different_file_name.txt";
      expect(testFile, isNot(reference));
    });

    test(".hashCode is the same for equivalent content", () async {
      expect(testFile.hashCode, equals(reference.hashCode));
    });

    test('.hashCode changes when Content changes', () async {
      testFile?.content = [3, 2, 1, 0];
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when ContentMimeType changes', () async {
      testFile?.contentMimeType = "application/orthros";
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when ContentType changes', () async {
      testFile?.contentType = EpubContentType.CSS;
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when FileName changes', () async {
      testFile?.fileName = "a_different_file_name";
      expect(testFile.hashCode, isNot(reference.hashCode));
    });
  });
}
