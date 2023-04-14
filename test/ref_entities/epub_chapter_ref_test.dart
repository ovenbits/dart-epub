library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:epub/src/ref_entities/epub_content_ref.dart';
import 'package:epub/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  var arch = new Archive();
  var bookRef = new EpubBookRef(
    epubArchive: arch,
    title: '',
    author: '',
    authorList: [],
    schema: EpubSchema.empty(),
    content: EpubContentRef(),
  );
  var contentFileRef = EpubTextContentFileRef(
    epubBookRef: bookRef,
    fileName: '',
    contentType: EpubContentType.OTHER,
    contentMimeType: '',
  );
  var reference = new EpubChapterRef(
    epubTextContentFileRef: contentFileRef,
    title: "A New Look at Chapters",
    contentFileName: "orthros",
    anchor: "anchor",
    subChapters: [],
  );

  EpubBookRef? bookRef2;
  EpubChapterRef? testChapterRef;
  setUp(() async {
    var arch2 = new Archive();
    bookRef2 = new EpubBookRef(
      epubArchive: arch2,
      title: '',
      author: '',
      authorList: [],
      schema: EpubSchema.empty(),
      content: EpubContentRef(),
    );
    var contentFileRef2 = new EpubTextContentFileRef(
      epubBookRef: bookRef2!,
      fileName: '',
      contentType: EpubContentType.OTHER,
      contentMimeType: '',
    );

    testChapterRef = EpubChapterRef(
      epubTextContentFileRef: contentFileRef2,
      anchor: "anchor",
      contentFileName: "orthros",
      subChapters: [],
      title: "A New Look at Chapters",
    );
  });

  tearDown(() async {
    testChapterRef = null;
    bookRef2 = null;
  });
  group("EpubChapterRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testChapterRef, equals(reference));
      });

      test("is false when Anchor changes", () async {
        testChapterRef?.anchor = "NotAnAnchor";
        expect(testChapterRef, isNot(reference));
      });

      test("is false when ContentFileName changes", () async {
        testChapterRef?.contentFileName = "NotOrthros";
        expect(testChapterRef, isNot(reference));
      });

      test("is false when SubChapters changes", () async {
        var subchapterContentFileRef = new EpubTextContentFileRef(
          epubBookRef: bookRef2!,
          fileName: '',
          contentType: EpubContentType.OTHER,
          contentMimeType: '',
        );
        var chapter = new EpubChapterRef(
          epubTextContentFileRef: subchapterContentFileRef,
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
          anchor: null,
          subChapters: [],
        );
        testChapterRef?.subChapters = [chapter];
        expect(testChapterRef, isNot(reference));
      });

      test("is false when Title changes", () async {
        testChapterRef?.title = "A Boring Old World";
        expect(testChapterRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testChapterRef.hashCode, equals(reference.hashCode));
      });

      test("is false when Anchor changes", () async {
        testChapterRef?.anchor = "NotAnAnchor";
        expect(testChapterRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentFileName changes", () async {
        testChapterRef?.contentFileName = "NotOrthros";
        expect(testChapterRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when SubChapters changes", () async {
        var subchapterContentFileRef = new EpubTextContentFileRef(
          epubBookRef: bookRef2!,
          fileName: '',
          contentType: EpubContentType.OTHER,
          contentMimeType: '',
        );
        var chapter = new EpubChapterRef(
          epubTextContentFileRef: subchapterContentFileRef,
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
          anchor: null,
          subChapters: [],
        );
        testChapterRef?.subChapters = [chapter];
        expect(testChapterRef, isNot(reference));
      });

      test("is false when Title changes", () async {
        testChapterRef?.title = "A Boring Old World";
        expect(testChapterRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
