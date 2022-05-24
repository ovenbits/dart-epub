library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:epub/src/ref_entities/epub_content_ref.dart';
import 'package:epub/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  var arch = new Archive();
  var epubRef = new EpubBookRef(
    epubArchive: arch,
    title: '',
    author: '',
    authorList: [],
    schema: EpubSchema.empty(),
    content: EpubContentRef(),
  );

  var reference = new EpubTextContentFileRef(
    epubBookRef: epubRef,
    contentMimeType: "application/test",
    contentType: EpubContentType.OTHER,
    fileName: "orthrosFile",
  );

  EpubTextContentFileRef? testFile;

  setUp(() async {
    var arch2 = new Archive();
    var epubRef2 = new EpubBookRef(
      epubArchive: arch2,
      title: '',
      author: '',
      authorList: [],
      schema: EpubSchema.empty(),
      content: EpubContentRef(),
    );

    testFile = EpubTextContentFileRef(
      epubBookRef: epubRef2,
      contentMimeType: "application/test",
      contentType: EpubContentType.OTHER,
      fileName: "orthrosFile",
    );
  });

  tearDown(() async {
    testFile = null;
  });
  group("EpubTextContentFile", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFile, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFile?.contentMimeType = "application/different";
        expect(testFile, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFile?.contentType = EpubContentType.CSS;
        expect(testFile, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFile?.fileName = "a_different_file_name.txt";
        expect(testFile, isNot(reference));
      });
    });
    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFile.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFile?.contentMimeType = "application/orthros";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFile?.contentType = EpubContentType.CSS;
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile?.fileName = "a_different_file_name";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
