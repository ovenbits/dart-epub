library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:epub/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub/src/ref_entities/epub_content_ref.dart';
import 'package:test/test.dart';

main() async {
  Archive arch = new Archive();
  EpubBookRef ref = EpubBookRef(
    epubArchive: arch,
    title: '',
    author: '',
    authorList: [],
    schema: EpubSchema.empty(),
    content: EpubContentRef(),
  );

  var reference = EpubByteContentFileRef(
    epubBookRef: ref,
    contentMimeType: "application/test",
    contentType: EpubContentType.OTHER,
    fileName: "orthrosFile",
  );

  EpubByteContentFileRef? testFileRef;

  setUp(() async {
    Archive arch2 = new Archive();
    EpubBookRef ref2 = EpubBookRef(
      epubArchive: arch2,
      title: '',
      author: '',
      authorList: [],
      schema: EpubSchema.empty(),
      content: EpubContentRef(),
    );

    testFileRef = EpubByteContentFileRef(
      epubBookRef: ref2,
      contentMimeType: "application/test",
      contentType: EpubContentType.OTHER,
      fileName: "orthrosFile",
    );
  });

  tearDown(() async {
    testFileRef = null;
  });

  group("EpubByteContentFileRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFileRef, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFileRef?.contentMimeType = "application/different";
        expect(testFileRef, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFileRef?.contentType = EpubContentType.CSS;
        expect(testFileRef, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFileRef?.fileName = "a_different_file_name.txt";
        expect(testFileRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFileRef.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFileRef?.contentMimeType = "application/orthros";
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFileRef?.contentType = EpubContentType.CSS;
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFileRef?.fileName = "a_different_file_name";
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
