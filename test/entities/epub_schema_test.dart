library epubreadertest;

import 'package:epub/epub.dart';
import 'package:epub/src/entities/epub_schema.dart';
import 'package:epub/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epub/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub/src/schema/navigation/epub_navigation_head.dart';
import 'package:epub/src/schema/navigation/epub_navigation_map.dart';
import 'package:epub/src/schema/opf/epub_guide.dart';
import 'package:epub/src/schema/opf/epub_manifest.dart';
import 'package:epub/src/schema/opf/epub_metadata.dart';
import 'package:epub/src/schema/opf/epub_spine.dart';
import 'package:epub/src/schema/opf/epub_version.dart';
import 'package:test/test.dart';

main() async {
  var reference = EpubSchema(
    package: EpubPackage.empty(),
    navigation: EpubNavigation.empty(),
    contentDirectoryPath: "some/random/path",
  );
  reference.package.version = EpubVersion.Epub2;

  EpubSchema? testSchema;
  setUp(() async {
    testSchema = EpubSchema(
      package: EpubPackage.empty(),
      navigation: EpubNavigation.empty(),
      contentDirectoryPath: "some/random/path",
    );
    testSchema?.package.version = EpubVersion.Epub2;
  });
  tearDown(() async {
    testSchema = null;
  });
  group("EpubSchema", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testSchema, equals(reference));
      });

      test("is false when Package changes", () async {
        var package = EpubPackage(
          version: EpubVersion.Epub3,
          metadata: EpubMetadata.empty(),
          manifest: EpubManifest(items: []),
          spine: EpubSpine(items: [], tableOfContents: null),
          guide: EpubGuide(items: []),
        );

        testSchema?.package = package;
        expect(testSchema, isNot(reference));
      });

      test("is false when Navigation changes", () async {
        testSchema?.navigation = EpubNavigation(
          head: EpubNavigationHead(metadata: []),
          docTitle: EpubNavigationDocTitle(titles: []),
          docAuthors: [EpubNavigationDocAuthor(authors: [])],
          navMap: EpubNavigationMap(points: []),
          pageList: null,
          navLists: [],
        );

        expect(testSchema, isNot(reference));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema?.contentDirectoryPath = "some/other/random/path/to/dev/null";
        expect(testSchema, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testSchema.hashCode, equals(reference.hashCode));
      });

      test("is false when Package changes", () async {
        var package = EpubPackage(
          version: EpubVersion.Epub3,
          metadata: EpubMetadata.empty(),
          manifest: EpubManifest(items: []),
          spine: EpubSpine(items: [], tableOfContents: null),
          guide: EpubGuide(items: []),
        );

        testSchema?.package = package;
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when Navigation changes", () async {
        testSchema?.navigation = EpubNavigation(
          head: EpubNavigationHead(metadata: []),
          docTitle: EpubNavigationDocTitle(titles: []),
          docAuthors: [EpubNavigationDocAuthor(authors: [])],
          navMap: EpubNavigationMap(points: []),
          pageList: null,
          navLists: [],
        );

        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema?.contentDirectoryPath = "some/other/random/path/to/dev/null";
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
