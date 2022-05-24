import 'package:quiver/core.dart';

class EpubManifestItem {
  EpubManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
    this.requiredNamespace,
    this.requiredModules,
    this.fallback,
    this.fallbackStyle,
  });

  String id;
  String href;
  String mediaType;
  String? requiredNamespace;
  String? requiredModules;
  String? fallback;
  String? fallbackStyle;

  @override
  int get hashCode => hashObjects([
        id.hashCode,
        href.hashCode,
        mediaType.hashCode,
        requiredNamespace.hashCode,
        requiredModules.hashCode,
        fallback.hashCode,
        fallbackStyle.hashCode,
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubManifestItem?;
    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id && href == otherAs.href && mediaType == otherAs.mediaType && requiredNamespace == otherAs.requiredNamespace && requiredModules == otherAs.requiredModules && fallback == otherAs.fallback && fallbackStyle == otherAs.fallbackStyle;
  }

  @override
  String toString() {
    return 'Id: $id, Href = $href, MediaType = $mediaType';
  }
}
