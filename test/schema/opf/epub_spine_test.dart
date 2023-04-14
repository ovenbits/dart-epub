library epubreadertest;

import 'dart:math';

import 'package:epub/src/schema/opf/epub_spine.dart';
import 'package:epub/src/schema/opf/epub_spine_item_ref.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final int length = 10;
  final RandomString randomString = new RandomString(new Random(123788));

  var reference = new EpubSpine(
    items: [
      EpubSpineItemRef(
        idRef: randomString.randomAlpha(length),
        isLinear: true,
      ),
    ],
    tableOfContents: randomString.randomAlpha(length),
  );

  EpubSpine? testSpine;
  setUp(() async {
    testSpine = new EpubSpine(
      items: List.from(reference.items),
      tableOfContents: reference.tableOfContents,
    );
  });
  tearDown(() async {
    testSpine = null;
  });

  group("EpubSpine", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testSpine, equals(reference));
      });
      test("is false when Items changes", () async {
        testSpine?.items = [
          EpubSpineItemRef(
            idRef: randomString.randomAlpha(length),
            isLinear: false,
          )
        ];
        expect(testSpine, isNot(reference));
      });
      test("is false when TableOfContents changes", () async {
        testSpine?.tableOfContents = randomString.randomAlpha(length);
        expect(testSpine, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testSpine.hashCode, equals(reference.hashCode));
      });
      test("is false when IsLinear changes", () async {
        testSpine?.items = [
          EpubSpineItemRef(
            idRef: randomString.randomAlpha(length),
            isLinear: false,
          )
        ];
        expect(testSpine.hashCode, isNot(reference.hashCode));
      });
      test("is false when TableOfContents changes", () async {
        testSpine?.tableOfContents = randomString.randomAlpha(length);
        expect(testSpine.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
