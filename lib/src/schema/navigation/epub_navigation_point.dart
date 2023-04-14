import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationPoint {
  EpubNavigationPoint({
    required this.id,
    required this.className,
    required this.playOrder,
    required this.navigationLabels,
    required this.content,
    required this.childNavigationPoints,
  });

  String id;
  String? className;
  String? playOrder;
  List<EpubNavigationLabel> navigationLabels;
  EpubNavigationContent content;
  List<EpubNavigationPoint> childNavigationPoints;

  @override
  int get hashCode {
    final objects = [
      id.hashCode,
      className.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels.map((label) => label.hashCode),
      ...childNavigationPoints.map((point) => point.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationPoint?;
    if (otherAs == null) {
      return false;
    }

    if (!collections.listsEqual(navigationLabels, otherAs.navigationLabels)) {
      return false;
    }

    if (!collections.listsEqual(childNavigationPoints, otherAs.childNavigationPoints)) return false;

    return id == otherAs.id && className == otherAs.className && playOrder == otherAs.playOrder && content == otherAs.content;
  }

  @override
  String toString() {
    return 'Id: $id, Content.Source: ${content.source}';
  }
}
