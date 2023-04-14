library epubreadertest;

import 'package:epub/epub.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubContent();

  EpubContent? testContent;
  EpubTextContentFile? textContentFile;
  EpubByteContentFile? byteContentFile;

  setUp(() async {
    testContent = EpubContent();

    textContentFile = EpubTextContentFile(
      content: "Some string",
      contentMimeType: "application/text",
      contentType: EpubContentType.OTHER,
      fileName: "orthros.txt",
    );

    byteContentFile = EpubByteContentFile(
      content: [0, 1, 2, 3],
      contentMimeType: "application/orthros",
      contentType: EpubContentType.OTHER,
      fileName: "orthros.bin",
    );
  });

  tearDown(() async {
    testContent = null;
    textContentFile = null;
    byteContentFile = null;
  });
  group("EpubContent", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testContent, equals(reference));
      });

      test("is false when Html changes", () async {
        testContent?.html["someKey"] = textContentFile!;
        expect(testContent, isNot(reference));
      });

      test("is false when Css changes", () async {
        testContent?.css["someKey"] = textContentFile!;
        expect(testContent, isNot(reference));
      });

      test("is false when Images changes", () async {
        testContent?.images["someKey"] = byteContentFile!;
        expect(testContent, isNot(reference));
      });

      test("is false when Fonts changes", () async {
        testContent?.fonts["someKey"] = byteContentFile!;
        expect(testContent, isNot(reference));
      });

      test("is false when AllFiles changes", () async {
        testContent?.allFiles["someKey"] = byteContentFile!;
        expect(testContent, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testContent.hashCode, equals(reference.hashCode));
      });

      test("is false when Html changes", () async {
        testContent?.html["someKey"] = textContentFile!;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Css changes", () async {
        testContent?.css["someKey"] = textContentFile!;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Images changes", () async {
        testContent?.images["someKey"] = byteContentFile!;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Fonts changes", () async {
        testContent?.fonts["someKey"] = byteContentFile!;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when AllFiles changes", () async {
        testContent?.allFiles["someKey"] = byteContentFile!;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
