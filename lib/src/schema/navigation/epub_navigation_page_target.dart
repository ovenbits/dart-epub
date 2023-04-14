import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_page_target_type.dart';

class EpubNavigationPageTarget {
  EpubNavigationPageTarget({
    required this.id,
    required this.value,
    required this.type,
    required this.className,
    required this.playOrder,
    required this.navigationLabels,
    required this.content,
  });

  final String? id;
  final String? value;
  final EpubNavigationPageTargetType type;
  final String? className;
  final String? playOrder;
  final List<EpubNavigationLabel> navigationLabels;
  final EpubNavigationContent? content;

  @override
  int get hashCode {
    final objects = [
      id.hashCode,
      value.hashCode,
      type.hashCode,
      className.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels.map((label) => label.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationPageTarget?;
    if (otherAs == null) {
      return false;
    }

    if (!(id == otherAs.id && value == otherAs.value && type == otherAs.type && className == otherAs.className && playOrder == otherAs.playOrder && content == otherAs.content)) {
      return false;
    }

    return collections.listsEqual(navigationLabels, otherAs.navigationLabels);
  }
}
