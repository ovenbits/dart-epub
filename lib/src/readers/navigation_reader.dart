import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:epub/src/schema/opf/epub_version.dart';
import 'package:xml/xml.dart' as xml;

import '../schema/navigation/epub_metadata.dart';
import '../schema/navigation/epub_navigation.dart';
import '../schema/navigation/epub_navigation_doc_author.dart';
import '../schema/navigation/epub_navigation_doc_title.dart';
import '../schema/navigation/epub_navigation_head.dart';
import '../schema/navigation/epub_navigation_head_meta.dart';
import '../schema/navigation/epub_navigation_label.dart';
import '../schema/navigation/epub_navigation_list.dart';
import '../schema/navigation/epub_navigation_map.dart';
import '../schema/navigation/epub_navigation_page_list.dart';
import '../schema/navigation/epub_navigation_page_target.dart';
import '../schema/navigation/epub_navigation_page_target_type.dart';
import '../schema/navigation/epub_navigation_point.dart';
import '../schema/navigation/epub_navigation_target.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_package.dart';
import '../utils/enum_from_string.dart';
import '../utils/zip_path_utils.dart';

class NavigationReader {
  static Future<EpubNavigation?> readNavigation(Archive epubArchive, String contentDirectoryPath, EpubPackage package) async {
    EpubNavigationHead head;
    EpubNavigationDocTitle docTitle;
    List<EpubNavigationDocAuthor> docAuthors = [];
    EpubNavigationMap navMap;
    EpubNavigationPageList? pageList;
    List<EpubNavigationList> navLists = [];

    final tocId = package.spine.tableOfContents;
    if (tocId == null || tocId.isEmpty) {
      if (package.version == EpubVersion.Epub2) {
        throw Exception('EPUB parsing error: TOC ID is empty.');
      }
      return null;
    }

    final tocManifestItem = package.manifest.items.firstWhereOrNull((EpubManifestItem item) => item.id.toLowerCase() == tocId.toLowerCase());
    if (tocManifestItem == null) {
      throw Exception('EPUB parsing error: TOC item $tocId not found in EPUB manifest.');
    }

    final tocFileEntryPath = ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);
    final tocFileEntry = epubArchive.files.firstWhereOrNull((ArchiveFile file) => file.name.toLowerCase() == tocFileEntryPath.toLowerCase());
    if (tocFileEntry == null) {
      throw Exception('EPUB parsing error: TOC file $tocFileEntryPath not found in archive.');
    }

    final containerDocument = xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

    final ncxNamespace = 'http://www.daisy.org/z3986/2005/ncx/';
    final ncxNode = containerDocument.findAllElements('ncx', namespace: ncxNamespace).firstOrNull;
    if (ncxNode == null) {
      throw Exception('EPUB parsing error: TOC file does not contain ncx element.');
    }

    final headNode = ncxNode.findAllElements('head', namespace: ncxNamespace).firstOrNull;
    if (headNode == null) {
      throw Exception('EPUB parsing error: TOC file does not contain head element.');
    }

    head = readNavigationHead(headNode);

    final docTitleNode = ncxNode.findElements('docTitle', namespace: ncxNamespace).firstOrNull;
    if (docTitleNode == null) {
      throw Exception('EPUB parsing error: TOC file does not contain docTitle element.');
    }

    docTitle = readNavigationDocTitle(docTitleNode);

    ncxNode.findElements('docAuthor', namespace: ncxNamespace).forEach((xml.XmlElement docAuthorNode) {
      final navigationDocAuthor = readNavigationDocAuthor(docAuthorNode);
      docAuthors.add(navigationDocAuthor);
    });

    final navMapNode = ncxNode.findElements('navMap', namespace: ncxNamespace).firstOrNull;
    if (navMapNode == null) {
      throw Exception('EPUB parsing error: TOC file does not contain navMap element.');
    }

    navMap = readNavigationMap(navMapNode);

    final pageListNode = ncxNode.findElements('pageList', namespace: ncxNamespace).firstOrNull;
    if (pageListNode != null) {
      pageList = readNavigationPageList(pageListNode);
    }

    ncxNode.findElements('navList', namespace: ncxNamespace).forEach((xml.XmlElement navigationListNode) {
      final navigationList = readNavigationList(navigationListNode);
      navLists.add(navigationList);
    });

    return EpubNavigation(
      head: head,
      docTitle: docTitle,
      docAuthors: docAuthors,
      navMap: navMap,
      pageList: pageList,
      navLists: navLists,
    );
  }

  static EpubNavigationContent readNavigationContent(xml.XmlElement navigationContentNode) {
    String? id;
    String source = '';

    navigationContentNode.attributes.forEach((xml.XmlAttribute navigationContentNodeAttribute) {
      final attributeValue = navigationContentNodeAttribute.value;
      switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'src':
          source = attributeValue;
          break;
      }
    });
    if (source.isEmpty) {
      throw Exception('Incorrect EPUB navigation content: content source is missing.');
    }

    return EpubNavigationContent(
      id: id,
      source: source,
    );
  }

  static EpubNavigationDocAuthor readNavigationDocAuthor(xml.XmlElement docAuthorNode) {
    List<String> authors = [];
    docAuthorNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == 'text') {
        authors.add(textNode.text);
      }
    });

    return EpubNavigationDocAuthor(authors: authors);
  }

  static EpubNavigationDocTitle readNavigationDocTitle(xml.XmlElement docTitleNode) {
    List<String> titles = [];
    docTitleNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == 'text') {
        titles.add(textNode.text);
      }
    });

    return EpubNavigationDocTitle(titles: titles);
  }

  static EpubNavigationHead readNavigationHead(xml.XmlElement headNode) {
    List<EpubNavigationHeadMeta> metadata = [];
    headNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement metaNode) {
      if (metaNode.name.local.toLowerCase() == 'meta') {
        String name = '';
        String? content;
        String? scheme;

        metaNode.attributes.forEach((xml.XmlAttribute metaNodeAttribute) {
          final attributeValue = metaNodeAttribute.value;
          switch (metaNodeAttribute.name.local.toLowerCase()) {
            case 'name':
              name = attributeValue;
              break;
            case 'content':
              content = attributeValue;
              break;
            case 'scheme':
              scheme = attributeValue;
              break;
          }
        });

        if (name.isEmpty) {
          throw Exception('Incorrect EPUB navigation meta: meta name is missing.');
        }
        if (content == null) {
          throw Exception('Incorrect EPUB navigation meta: meta content is missing.');
        }

        final meta = EpubNavigationHeadMeta(
          name: name,
          content: content!,
          scheme: scheme,
        );

        metadata.add(meta);
      }
    });

    return EpubNavigationHead(metadata: metadata);
  }

  static EpubNavigationLabel readNavigationLabel(xml.XmlElement navigationLabelNode) {
    final navigationLabelTextNode = navigationLabelNode.findElements('text', namespace: navigationLabelNode.name.namespaceUri).firstOrNull;
    if (navigationLabelTextNode == null) {
      throw Exception('Incorrect EPUB navigation label: label text element is missing.');
    }

    return EpubNavigationLabel(text: navigationLabelTextNode.text);
  }

  static EpubNavigationList readNavigationList(xml.XmlElement navigationListNode) {
    String? id;
    String? className;
    List<EpubNavigationLabel> navigationLabels = [];
    List<EpubNavigationTarget> navigationTargets = [];

    navigationListNode.attributes.forEach((xml.XmlAttribute navigationListNodeAttribute) {
      final attributeValue = navigationListNodeAttribute.value;
      switch (navigationListNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'class':
          className = attributeValue;
          break;
      }
    });

    navigationListNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationListChildNode) {
      switch (navigationListChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = readNavigationLabel(navigationListChildNode);
          navigationLabels.add(navigationLabel);
          break;
        case 'navtarget':
          final navigationTarget = readNavigationTarget(navigationListChildNode);
          navigationTargets.add(navigationTarget);
          break;
      }
    });

    if (navigationLabels.isEmpty) {
      throw Exception('Incorrect EPUB navigation page target: at least one navLabel element is required.');
    }

    return EpubNavigationList(
      id: id,
      className: className,
      navigationLabels: navigationLabels,
      navigationTargets: navigationTargets,
    );
  }

  static EpubNavigationMap readNavigationMap(xml.XmlElement navigationMapNode) {
    List<EpubNavigationPoint> points = [];

    navigationMapNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'navpoint') {
        final navigationPoint = readNavigationPoint(navigationPointNode);
        points.add(navigationPoint);
      }
    });

    return EpubNavigationMap(points: points);
  }

  static EpubNavigationPageList readNavigationPageList(xml.XmlElement navigationPageListNode) {
    List<EpubNavigationPageTarget> targets = [];

    navigationPageListNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement pageTargetNode) {
      if (pageTargetNode.name.local == 'pageTarget') {
        final pageTarget = readNavigationPageTarget(pageTargetNode);
        targets.add(pageTarget);
      }
    });

    return EpubNavigationPageList(targets: targets);
  }

  static EpubNavigationPageTarget readNavigationPageTarget(xml.XmlElement navigationPageTargetNode) {
    String? id;
    String? value;
    EpubNavigationPageTargetType type = EpubNavigationPageTargetType.UNDEFINED;
    String? className;
    String? playOrder;
    List<EpubNavigationLabel> navigationLabels = [];
    EpubNavigationContent? content;

    navigationPageTargetNode.attributes.forEach((xml.XmlAttribute navigationPageTargetNodeAttribute) {
      final attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'value':
          value = attributeValue;
          break;
        case 'type':
          var converter = EnumFromString<EpubNavigationPageTargetType>(EpubNavigationPageTargetType.values);
          type = converter.get(attributeValue) ?? EpubNavigationPageTargetType.UNDEFINED;
          break;
        case 'class':
          className = attributeValue;
          break;
        case 'playorder':
          playOrder = attributeValue;
          break;
      }
    });
    if (type == EpubNavigationPageTargetType.UNDEFINED) {
      throw Exception('Incorrect EPUB navigation page target: page target type is missing.');
    }

    navigationPageTargetNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationPageTargetChildNode) {
      switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = readNavigationLabel(navigationPageTargetChildNode);
          navigationLabels.add(navigationLabel);
          break;
        case 'content':
          content = readNavigationContent(navigationPageTargetChildNode);
          break;
      }
    });

    if (navigationLabels.isEmpty) {
      throw Exception('Incorrect EPUB navigation page target: at least one navLabel element is required.');
    }

    return EpubNavigationPageTarget(
      id: id,
      value: value,
      type: type,
      className: className,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content,
    );
  }

  static EpubNavigationPoint readNavigationPoint(xml.XmlElement navigationPointNode) {
    String id = '';
    String? className;
    String? playOrder;
    List<EpubNavigationLabel> navigationLabels = [];
    EpubNavigationContent? content;
    List<EpubNavigationPoint> childNavigationPoints = [];

    navigationPointNode.attributes.forEach((xml.XmlAttribute navigationPointNodeAttribute) {
      final attributeValue = navigationPointNodeAttribute.value;
      switch (navigationPointNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'class':
          className = attributeValue;
          break;
        case 'playorder':
          playOrder = attributeValue;
          break;
      }
    });

    if (id.isEmpty) {
      throw Exception('Incorrect EPUB navigation point: point ID is missing.');
    }

    navigationPointNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = readNavigationLabel(navigationPointChildNode);
          navigationLabels.add(navigationLabel);
          break;
        case 'content':
          content = readNavigationContent(navigationPointChildNode);
          break;
        case 'navpoint':
          final childNavigationPoint = readNavigationPoint(navigationPointChildNode);
          childNavigationPoints.add(childNavigationPoint);
          break;
      }
    });

    if (navigationLabels.isEmpty) {
      throw Exception('EPUB parsing error: navigation point $id should contain at least one navigation label.');
    }

    if (content == null) {
      throw Exception('EPUB parsing error: navigation point $id should contain content.');
    }

    return EpubNavigationPoint(
      id: id,
      className: className,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content!,
      childNavigationPoints: childNavigationPoints,
    );
  }

  static EpubNavigationTarget readNavigationTarget(xml.XmlElement navigationTargetNode) {
    String id = '';
    String? className;
    String? value;
    String? playOrder;
    List<EpubNavigationLabel> navigationLabels = [];
    EpubNavigationContent? content;

    navigationTargetNode.attributes.forEach((xml.XmlAttribute navigationPageTargetNodeAttribute) {
      final attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'value':
          value = attributeValue;
          break;
        case 'class':
          className = attributeValue;
          break;
        case 'playorder':
          playOrder = attributeValue;
          break;
      }
    });

    if (id.isEmpty) {
      throw Exception('Incorrect EPUB navigation target: navigation target ID is missing.');
    }

    navigationTargetNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationTargetChildNode) {
      switch (navigationTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = readNavigationLabel(navigationTargetChildNode);
          navigationLabels.add(navigationLabel);
          break;
        case 'content':
          content = readNavigationContent(navigationTargetChildNode);
          break;
      }
    });

    if (navigationLabels.isEmpty) {
      throw Exception('Incorrect EPUB navigation target: at least one navLabel element is required.');
    }

    return EpubNavigationTarget(
      id: id,
      className: className,
      value: value,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content,
    );
  }
}
