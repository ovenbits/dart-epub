library epubreadertest;

import 'dart:math';

import 'package:epub/epub.dart';
import 'package:epub/src/schema/opf/epub_version.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final int length = 10;

  final RandomDataGenerator generator = new RandomDataGenerator(new Random(123778), length);

  var reference = generator.randomEpubPackage()..version = EpubVersion.Epub3;

  EpubPackage? testPackage;
  setUp(() async {
    testPackage = EpubPackage(
      guide: reference.guide,
      manifest: reference.manifest,
      metadata: reference.metadata,
      spine: reference.spine,
      version: reference.version,
    );
  });
  tearDown(() async {
    testPackage = null;
  });

  group("EpubSpine", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testPackage, equals(reference));
      });
      test("is false when Guide changes", () async {
        testPackage?.guide = generator.randomEpubGuide();
        expect(testPackage, isNot(reference));
      });
      test("is false when Manifest changes", () async {
        testPackage?.manifest = generator.randomEpubManifest();
        expect(testPackage, isNot(reference));
      });
      test("is false when Metadata changes", () async {
        testPackage?.metadata = generator.randomEpubMetadata();
        expect(testPackage, isNot(reference));
      });
      test("is false when Spine changes", () async {
        testPackage?.spine = generator.randomEpubSpine();
        expect(testPackage, isNot(reference));
      });
      test("is false when Version changes", () async {
        testPackage?.version = testPackage?.version == EpubVersion.Epub2 ? EpubVersion.Epub3 : EpubVersion.Epub2;
        expect(testPackage, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testPackage.hashCode, equals(reference.hashCode));
      });
      test("is false when Guide changes", () async {
        testPackage?.guide = generator.randomEpubGuide();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Manifest changes", () async {
        testPackage?.manifest = generator.randomEpubManifest();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Metadata changes", () async {
        testPackage?.metadata = generator.randomEpubMetadata();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Spine changes", () async {
        testPackage?.spine = generator.randomEpubSpine();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Version changes", () async {
        testPackage?.version = testPackage?.version == EpubVersion.Epub2 ? EpubVersion.Epub3 : EpubVersion.Epub2;
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
