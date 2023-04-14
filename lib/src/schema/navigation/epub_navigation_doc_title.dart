import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocTitle {
  EpubNavigationDocTitle({required this.titles});

  final List<String> titles;

  @override
  int get hashCode {
    var objects = titles.map((title) => title.hashCode);
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocTitle?;
    if (otherAs == null) return false;

    return collections.listsEqual(titles, otherAs.titles);
  }
}
