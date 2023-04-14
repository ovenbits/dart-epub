import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocAuthor {
  EpubNavigationDocAuthor({required this.authors});

  final List<String> authors;

  @override
  int get hashCode {
    final objects = authors.map((author) => author.hashCode);
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocAuthor?;
    if (otherAs == null) return false;

    return collections.listsEqual(authors, otherAs.authors);
  }
}
