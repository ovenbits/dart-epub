import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:xml/xml.dart' as xml;

class RootFilePathReader {
  static Future<String> getRootFilePath(Archive epubArchive) async {
    const EPUB_CONTAINER_FILE_PATH = 'META-INF/container.xml';

    final containerFileEntry = epubArchive.files.firstWhere((ArchiveFile file) => file.name == EPUB_CONTAINER_FILE_PATH, orElse: () => null);
    if (containerFileEntry == null) {
      throw Exception('EPUB parsing error: $EPUB_CONTAINER_FILE_PATH file not found in archive.');
    }

    final containerDocument = xml.XmlDocument.parse(convert.utf8.decode(containerFileEntry.content));
    final packageElement = containerDocument.findAllElements('container', namespace: 'urn:oasis:names:tc:opendocument:xmlns:container').firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (packageElement == null) {
      throw Exception('EPUB parsing error: Invalid epub container');
    }

    xml.XmlElement rootFileElement = packageElement.descendants.firstWhere((xml.XmlNode testElem) => (testElem is xml.XmlElement) && 'rootfile' == testElem.name.local, orElse: () => null);

    return rootFileElement.getAttribute('full-path');
  }
}
