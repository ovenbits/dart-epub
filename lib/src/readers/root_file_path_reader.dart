import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:xml/xml.dart' as xml;

class RootFilePathReader {
  static Future<String?> getRootFilePath(Archive epubArchive) async {
    const EPUB_CONTAINER_FILE_PATH = 'META-INF/container.xml';

    final containerFileEntry = epubArchive.files.firstWhereOrNull((file) => file.name == EPUB_CONTAINER_FILE_PATH);
    if (containerFileEntry == null) {
      throw Exception('EPUB parsing error: $EPUB_CONTAINER_FILE_PATH file not found in archive.');
    }

    final containerDocument = xml.XmlDocument.parse(convert.utf8.decode(containerFileEntry.content));
    final packageElement = containerDocument.findAllElements('container', namespace: 'urn:oasis:names:tc:opendocument:xmlns:container').firstOrNull;
    if (packageElement == null) {
      throw Exception('EPUB parsing error: Invalid epub container');
    }

    final rootFileElement = packageElement.descendants.firstWhereOrNull((xml.XmlNode testElem) => (testElem is xml.XmlElement) && 'rootfile' == testElem.name.local);

    return rootFileElement?.getAttribute('full-path');
  }
}
