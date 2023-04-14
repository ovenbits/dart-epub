library epubreadertest;

import 'dart:math';

import 'package:epub/src/schema/opf/epub_guide_reference.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final RandomDataGenerator generator = new RandomDataGenerator(new Random(123778), 10);

  var reference = generator.randomEpubGuideReference();

  EpubGuideReference? testGuideReference;
  setUp(() async {
    testGuideReference = EpubGuideReference(
      href: reference.href,
      title: reference.title,
      type: reference.type,
    );
  });
  tearDown(() async {
    testGuideReference = null;
  });
  group("EpubGuideReference", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testGuideReference, equals(reference));
      });

      test("is false when Href changes", () async {
        testGuideReference?.href = "A different href";

        expect(testGuideReference, isNot(reference));
      });

      test("is false when Title changes", () async {
        testGuideReference?.title = "A different Title";
        expect(testGuideReference, isNot(reference));
      });

      test("is false when Type changes", () async {
        testGuideReference?.type = "Some different type";
        expect(testGuideReference, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testGuideReference.hashCode, equals(reference.hashCode));
      });

      test("is false when Href changes", () async {
        testGuideReference?.href = "A different href";

        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testGuideReference?.title = "A different Title";
        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });

      test("is false when Type changes", () async {
        testGuideReference?.type = "Some different type";
        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
