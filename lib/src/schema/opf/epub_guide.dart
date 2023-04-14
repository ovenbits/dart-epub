import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_guide_reference.dart';

class EpubGuide {
  EpubGuide({required this.items});

  final List<EpubGuideReference> items;

  @override
  int get hashCode {
    final objects = items.map((item) => item.hashCode);
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubGuide?;
    if (otherAs == null) {
      return false;
    }

    return collections.listsEqual(items, otherAs.items);
  }
}
