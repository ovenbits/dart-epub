library epubreadertest;

import 'dart:math';

import 'package:epub/src/schema/navigation/epub_navigation_label.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final RandomDataGenerator generator = new RandomDataGenerator(new Random(123778), 10);

  final EpubNavigationLabel reference = generator.randomEpubNavigationLabel();

  EpubNavigationLabel? testNavigationLabel;
  setUp(() async {
    testNavigationLabel = EpubNavigationLabel(text: reference.text);
  });
  tearDown(() async {
    testNavigationLabel = null;
  });
  group("EpubNavigationLabel", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationLabel, equals(reference));
      });

      test("is false when Text changes", () async {
        testNavigationLabel?.text = generator.randomString();
        expect(testNavigationLabel, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationLabel.hashCode, equals(reference.hashCode));
      });

      test("is false when Metadata changes", () async {
        testNavigationLabel?.text = generator.randomString();
        expect(testNavigationLabel.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
