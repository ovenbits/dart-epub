import 'package:epub/src/schema/opf/epub_package.dart';
import 'package:epub/src/schema/opf/epub_version.dart';
import 'package:epub/src/writers/epub_guide_writer.dart';
import 'package:epub/src/writers/epub_manifest_writer.dart';
import 'package:epub/src/writers/epub_spine_writer.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;
import 'epub_metadata_writer.dart';

class EpubPackageWriter {
  static const String _namespace = 'http://www.idpf.org/2007/opf';

  static String writeContent(EpubPackage package) {
    var builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');

    builder.element('package', attributes: {
      'version': package.version == EpubVersion.Epub2 ? '2.0' : '3.0',
      'unique-identifier': 'etextno',
    }, nest: () {
      builder.namespace(_namespace);

      EpubMetadataWriter.writeMetadata(builder, package.metadata, package.version);
      EpubManifestWriter.writeManifest(builder, package.manifest);
      EpubSpineWriter.writeSpine(builder, package.spine);

      if (package.guide != null) {
        EpubGuideWriter.writeGuide(builder, package.guide!);
      }
    });

    return builder.buildDocument().toXmlString(pretty: false);
  }
}
