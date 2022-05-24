library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:epub/src/ref_entities/epub_content_ref.dart';
import 'package:epub/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  Archive arch = new Archive();
  var reference = EpubBookRef(
    epubArchive: arch,
    author: "orthros",
    authorList: ["orthros"],
    schema: EpubSchema.empty(),
    title: "A Dissertation on Epubs",
    content: EpubContentRef(),
  );

  EpubBookRef? testBookRef;
  setUp(() async {
    testBookRef = EpubBookRef(
      epubArchive: arch,
      author: "orthros",
      authorList: ["orthros"],
      schema: EpubSchema.empty(),
      title: "A Dissertation on Epubs",
      content: EpubContentRef(),
    );
  });
  tearDown(() async {
    testBookRef = null;
  });
  group("EpubBookRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBookRef, equals(reference));
      });

      test("is false when Content changes", () async {
        var file = new EpubTextContentFileRef(
          epubBookRef: testBookRef!,
          contentMimeType: "application/txt",
          contentType: EpubContentType.OTHER,
          fileName: "orthros.txt",
        );

        EpubContentRef content = new EpubContentRef();
        content.allFiles["hello"] = file;

        testBookRef?.content = content;

        expect(testBookRef, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBookRef?.author = "NotOrthros";
        expect(testBookRef, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBookRef?.authorList = ["NotOrthros"];
        expect(testBookRef, isNot(reference));
      });

      test("is false when Schema changes", () async {
        var schema = EpubSchema(
          package: EpubPackage.empty(),
          navigation: null,
          contentDirectoryPath: "some/random/path",
        );
        testBookRef?.schema = schema;
        expect(testBookRef, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBookRef?.title = "The Philosophy of Epubs";
        expect(testBookRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBookRef.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        var file = new EpubTextContentFileRef(
          epubBookRef: testBookRef!,
          contentMimeType: "application/txt",
          contentType: EpubContentType.OTHER,
          fileName: "orthros.txt",
        );

        EpubContentRef content = new EpubContentRef();
        content.allFiles["hello"] = file;

        testBookRef?.content = content;

        expect(testBookRef, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBookRef?.author = "NotOrthros";
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBookRef?.authorList = ["NotOrthros"];
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
      test("is false when Schema changes", () async {
        var schema = EpubSchema(
          package: EpubPackage.empty(),
          navigation: null,
          contentDirectoryPath: "some/random/path",
        );
        testBookRef?.schema = schema;
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBookRef?.title = "The Philosophy of Epubs";
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
