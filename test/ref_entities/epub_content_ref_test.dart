library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:epub/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub/src/ref_entities/epub_content_ref.dart';
import 'package:epub/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubContentRef();

  EpubContentRef? testContent;
  EpubTextContentFileRef? textContentFile;
  EpubByteContentFileRef? byteContentFile;

  setUp(() async {
    var arch = new Archive();
    var refBook = new EpubBookRef(
      epubArchive: arch,
      title: '',
      author: '',
      authorList: [],
      schema: EpubSchema.empty(),
      content: EpubContentRef(),
    );

    testContent = new EpubContentRef();

    textContentFile = new EpubTextContentFileRef(
      epubBookRef: refBook,
      fileName: "orthros.txt",
      contentType: EpubContentType.OTHER,
      contentMimeType: "application/text",
    );

    byteContentFile = new EpubByteContentFileRef(
      epubBookRef: refBook,
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
  group("EpubContentRef", () {
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
