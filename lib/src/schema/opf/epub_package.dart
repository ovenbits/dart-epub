import 'package:quiver/core.dart';

import 'epub_guide.dart';
import 'epub_manifest.dart';
import 'epub_metadata.dart';
import 'epub_spine.dart';
import 'epub_version.dart';

class EpubPackage {
  EpubPackage({
    required this.version,
    required this.metadata,
    required this.manifest,
    required this.spine,
    this.guide,
  });

  factory EpubPackage.empty() => EpubPackage(
        version: EpubVersion.Epub2,
        metadata: EpubMetadata.empty(),
        manifest: EpubManifest(items: []),
        spine: EpubSpine(items: [], tableOfContents: null),
      );

  EpubVersion version;
  EpubMetadata metadata;
  EpubManifest manifest;
  EpubSpine spine;
  EpubGuide? guide;

  @override
  int get hashCode => hashObjects([
        version.hashCode,
        metadata.hashCode,
        manifest.hashCode,
        spine.hashCode,
        guide.hashCode,
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubPackage?;
    if (otherAs == null) {
      return false;
    }

    return version == otherAs.version && metadata == otherAs.metadata && manifest == otherAs.manifest && spine == otherAs.spine && guide == otherAs.guide;
  }
}
