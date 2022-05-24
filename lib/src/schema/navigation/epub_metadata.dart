import 'package:quiver/core.dart';

class EpubNavigationContent {
  EpubNavigationContent({required this.id, required this.source});

  final String? id;
  final String source;

  @override
  int get hashCode => hash2(id.hashCode, source.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationContent?;
    if (otherAs == null) return false;
    return id == otherAs.id && source == otherAs.source;
  }

  @override
  String toString() {
    return 'Source: $source';
  }
}
