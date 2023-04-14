import 'package:quiver/core.dart';

class EpubNavigationHeadMeta {
  EpubNavigationHeadMeta({required this.name, required this.content, required this.scheme});

  String name;
  String content;
  String? scheme;

  @override
  int get hashCode => hash3(name.hashCode, content.hashCode, scheme.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationHeadMeta?;
    if (otherAs == null) {
      return false;
    }

    return name == otherAs.name && content == otherAs.content && scheme == otherAs.scheme;
  }
}
