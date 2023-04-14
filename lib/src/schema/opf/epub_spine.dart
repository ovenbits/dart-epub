import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_spine_item_ref.dart';

class EpubSpine {
  EpubSpine({required this.tableOfContents, required this.items});

  String? tableOfContents;
  List<EpubSpineItemRef> items;

  @override
  int get hashCode {
    var objs = [
      tableOfContents.hashCode,
      ...items.map((item) => item.hashCode),
    ];
    return hashObjects(objs);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubSpine?;
    if (otherAs == null) return false;

    if (!collections.listsEqual(items, otherAs.items)) {
      return false;
    }

    return tableOfContents == otherAs.tableOfContents;
  }
}
