library epubreadertest;

import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:test/test.dart';

main() async {
  var reference = EpubBook(
    author: "orthros",
    authorList: ["orthros"],
    chapters: [EpubChapter.empty()],
    content: EpubContent(),
    coverImage: Image(100, 100),
    schema: EpubSchema.empty(),
    title: "A Dissertation on Epubs",
  );

  EpubBook? testBook;
  setUp(() async {
    testBook = EpubBook(
      author: "orthros",
      authorList: ["orthros"],
      chapters: [EpubChapter.empty()],
      content: EpubContent(),
      coverImage: Image(100, 100),
      schema: EpubSchema.empty(),
      title: "A Dissertation on Epubs",
    );
  });
  tearDown(() async {
    testBook = null;
  });
  group("EpubBook", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBook, equals(reference));
      });

      test("is false when Content changes", () async {
        var file = EpubTextContentFile(
          content: "Hello",
          contentMimeType: "application/txt",
          contentType: EpubContentType.OTHER,
          fileName: "orthros.txt",
        );

        EpubContent content = EpubContent();
        content.allFiles["hello"] = file;
        testBook?.content = content;

        expect(testBook, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBook?.author = "NotOrthros";
        expect(testBook, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBook?.authorList = ["NotOrthros"];
        expect(testBook, isNot(reference));
      });

      test("is false when Chapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
          anchor: null,
          htmlContent: '',
          subChapters: [],
        );
        testBook?.chapters = [chapter];
        expect(testBook, isNot(reference));
      });

      test("is false when CoverImage changes", () async {
        testBook?.coverImage = new Image(200, 200);
        expect(testBook, isNot(reference));
      });

      test("is false when Schema changes", () async {
        var schema = EpubSchema(
          package: EpubPackage.empty(),
          navigation: null,
          contentDirectoryPath: "some/random/path",
        );
        testBook?.schema = schema;
        expect(testBook, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBook?.title = "The Philosophy of Epubs";
        expect(testBook, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBook.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        var file = EpubTextContentFile(
          content: "Hello",
          contentMimeType: "application/txt",
          contentType: EpubContentType.OTHER,
          fileName: "orthros.txt",
        );

        EpubContent content = new EpubContent();
        content.allFiles["hello"] = file;
        testBook?.content = content;

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Author changes", () async {
        testBook?.author = "NotOrthros";
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBook?.authorList = ["NotOrthros"];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Chapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
          anchor: null,
          htmlContent: '',
          subChapters: [],
        );
        testBook?.chapters = [chapter];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when CoverImage changes", () async {
        testBook?.coverImage = new Image(200, 200);
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Schema changes", () async {
        var schema = new EpubSchema(
          package: EpubPackage.empty(),
          navigation: null,
          contentDirectoryPath: "some/random/path",
        );
        testBook?.schema = schema;
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBook?.title = "The Philosophy of Epubs";
        expect(testBook.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
