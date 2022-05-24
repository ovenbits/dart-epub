import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_label.dart';
import 'epub_navigation_target.dart';

class EpubNavigationList {
  EpubNavigationList({required this.id, required this.className, required this.navigationLabels, required this.navigationTargets});

  final String? id;
  final String? className;
  final List<EpubNavigationLabel> navigationLabels;
  final List<EpubNavigationTarget> navigationTargets;

  @override
  int get hashCode {
    final objects = [
      id.hashCode,
      className.hashCode,
      ...navigationLabels.map((label) => label.hashCode),
      ...navigationTargets.map((target) => target.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationList?;
    if (otherAs == null) return false;

    if (!(id == otherAs.id && className == otherAs.className)) {
      return false;
    }

    if (!collections.listsEqual(navigationLabels, otherAs.navigationLabels)) {
      return false;
    }

    if (!collections.listsEqual(navigationTargets, otherAs.navigationTargets)) {
      return false;
    }

    return true;
  }
}
