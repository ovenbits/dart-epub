import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:xml/xml.dart' as xml;

import '../schema/opf/epub_guide.dart';
import '../schema/opf/epub_guide_reference.dart';
import '../schema/opf/epub_manifest.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_metadata_contributor.dart';
import '../schema/opf/epub_metadata_creator.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';
import '../schema/opf/epub_version.dart';

class PackageReader {
  static EpubGuide readGuide(xml.XmlElement guideNode) {
    List<EpubGuideReference> items = [];

    guideNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement guideReferenceNode) {
      if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
        String type = '';
        String? title;
        String href = '';

        guideReferenceNode.attributes.forEach((xml.XmlAttribute guideReferenceNodeAttribute) {
          final attributeValue = guideReferenceNodeAttribute.value;
          switch (guideReferenceNodeAttribute.name.local.toLowerCase()) {
            case 'type':
              type = attributeValue;
              break;
            case 'title':
              title = attributeValue;
              break;
            case 'href':
              href = attributeValue;
              break;
          }
        });

        if (type.isEmpty) {
          throw Exception('Incorrect EPUB guide: item type is missing');
        }

        if (href.isEmpty) {
          throw Exception('Incorrect EPUB guide: item href is missing');
        }

        final guideReference = EpubGuideReference(
          type: type,
          title: title,
          href: href,
        );

        items.add(guideReference);
      }
    });
    return EpubGuide(items: items);
  }

  static EpubManifest readManifest(xml.XmlElement manifestNode) {
    List<EpubManifestItem> items = [];

    manifestNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == 'item') {
        String id = '';
        String href = '';
        String mediaType = '';
        String? requiredNamespace;
        String? requiredModules;
        String? fallback;
        String? fallbackStyle;

        manifestItemNode.attributes.forEach((xml.XmlAttribute manifestItemNodeAttribute) {
          final attributeValue = manifestItemNodeAttribute.value;
          switch (manifestItemNodeAttribute.name.local.toLowerCase()) {
            case 'id':
              id = attributeValue;
              break;
            case 'href':
              href = attributeValue;
              break;
            case 'media-type':
              mediaType = attributeValue;
              break;
            case 'required-namespace':
              requiredNamespace = attributeValue;
              break;
            case 'required-modules':
              requiredModules = attributeValue;
              break;
            case 'fallback':
              fallback = attributeValue;
              break;
            case 'fallback-style':
              fallbackStyle = attributeValue;
              break;
          }
        });

        if (id.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item ID is missing');
        }
        if (href.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item href is missing');
        }
        if (mediaType.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item media type is missing');
        }

        final manifestItem = EpubManifestItem(
          id: id,
          href: href,
          mediaType: mediaType,
          requiredNamespace: requiredNamespace,
          requiredModules: requiredModules,
          fallback: fallback,
          fallbackStyle: fallbackStyle,
        );

        items.add(manifestItem);
      }
    });

    return EpubManifest(items: items);
  }

  static EpubMetadata readMetadata(xml.XmlElement metadataNode, EpubVersion epubVersion) {
    List<String> titles = [];
    List<EpubMetadataCreator> creators = [];
    List<String> subjects = [];
    String? description;
    List<String> publishers = [];
    List<EpubMetadataContributor> contributors = [];
    List<EpubMetadataDate> dates = [];
    List<String> types = [];
    List<String> formats = [];
    List<EpubMetadataIdentifier> identifiers = [];
    List<String> sources = [];
    List<String> languages = [];
    List<String> relations = [];
    List<String> coverages = [];
    List<String> rights = [];
    List<EpubMetadataMeta> metaItems = [];

    metadataNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement metadataItemNode) {
      final innerText = metadataItemNode.text;
      switch (metadataItemNode.name.local.toLowerCase()) {
        case 'title':
          titles.add(innerText);
          break;
        case 'creator':
          final creator = readMetadataCreator(metadataItemNode);
          creators.add(creator);
          break;
        case 'subject':
          subjects.add(innerText);
          break;
        case 'description':
          description = innerText;
          break;
        case 'publisher':
          publishers.add(innerText);
          break;
        case 'contributor':
          final contributor = readMetadataContributor(metadataItemNode);
          contributors.add(contributor);
          break;
        case 'date':
          final date = readMetadataDate(metadataItemNode);
          dates.add(date);
          break;
        case 'type':
          types.add(innerText);
          break;
        case 'format':
          formats.add(innerText);
          break;
        case 'identifier':
          final identifier = readMetadataIdentifier(metadataItemNode);
          identifiers.add(identifier);
          break;
        case 'source':
          sources.add(innerText);
          break;
        case 'language':
          languages.add(innerText);
          break;
        case 'relation':
          relations.add(innerText);
          break;
        case 'coverage':
          coverages.add(innerText);
          break;
        case 'rights':
          rights.add(innerText);
          break;
        case 'meta':
          if (epubVersion == EpubVersion.Epub2) {
            final meta = readMetadataMetaVersion2(metadataItemNode);
            metaItems.add(meta);
          } else if (epubVersion == EpubVersion.Epub3) {
            final meta = readMetadataMetaVersion3(metadataItemNode);
            metaItems.add(meta);
          }
          break;
      }
    });

    return EpubMetadata(
      titles: titles,
      creators: creators,
      subjects: subjects,
      description: description,
      publishers: publishers,
      contributors: contributors,
      dates: dates,
      types: types,
      formats: formats,
      identifiers: identifiers,
      sources: sources,
      languages: languages,
      relations: relations,
      coverages: coverages,
      rights: rights,
      metaItems: metaItems,
    );
  }

  static EpubMetadataContributor readMetadataContributor(xml.XmlElement metadataContributorNode) {
    String? fileAs;
    String? role;

    metadataContributorNode.attributes.forEach((xml.XmlAttribute metadataContributorNodeAttribute) {
      final attributeValue = metadataContributorNodeAttribute.value;
      switch (metadataContributorNodeAttribute.name.local.toLowerCase()) {
        case 'role':
          role = attributeValue;
          break;
        case 'file-as':
          fileAs = attributeValue;
          break;
      }
    });

    return EpubMetadataContributor(
      contributor: metadataContributorNode.text,
      fileAs: fileAs,
      role: role,
    );
  }

  static EpubMetadataCreator readMetadataCreator(xml.XmlElement metadataCreatorNode) {
    String? fileAs;
    String? role;

    metadataCreatorNode.attributes.forEach((xml.XmlAttribute metadataCreatorNodeAttribute) {
      final attributeValue = metadataCreatorNodeAttribute.value;
      switch (metadataCreatorNodeAttribute.name.local.toLowerCase()) {
        case 'role':
          role = attributeValue;
          break;
        case 'file-as':
          fileAs = attributeValue;
          break;
      }
    });

    return EpubMetadataCreator(
      creator: metadataCreatorNode.text,
      fileAs: fileAs,
      role: role,
    );
  }

  static EpubMetadataDate readMetadataDate(xml.XmlElement metadataDateNode) {
    final eventAttribute = metadataDateNode.getAttribute('event', namespace: metadataDateNode.name.namespaceUri);
    final event = eventAttribute != null && eventAttribute.isNotEmpty ? eventAttribute : null;

    return EpubMetadataDate(
      date: metadataDateNode.text,
      event: event,
    );
  }

  static EpubMetadataIdentifier readMetadataIdentifier(xml.XmlElement metadataIdentifierNode) {
    String? id;
    String? scheme;

    metadataIdentifierNode.attributes.forEach((xml.XmlAttribute metadataIdentifierNodeAttribute) {
      final attributeValue = metadataIdentifierNodeAttribute.value;
      switch (metadataIdentifierNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'scheme':
          scheme = attributeValue;
          break;
      }
    });

    return EpubMetadataIdentifier(
      id: id,
      scheme: scheme,
      identifier: metadataIdentifierNode.text,
    );
  }

  static EpubMetadataMeta readMetadataMetaVersion2(xml.XmlElement metadataMetaNode) {
    String? name;
    String? content;

    metadataMetaNode.attributes.forEach((xml.XmlAttribute metadataMetaNodeAttribute) {
      final attributeValue = metadataMetaNodeAttribute.value;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case 'name':
          name = attributeValue;
          break;
        case 'content':
          content = attributeValue;
          break;
      }
    });

    return EpubMetadataMeta(
      name: name,
      content: content,
      id: null,
      refines: null,
      property: null,
      scheme: null,
    );
  }

  static EpubMetadataMeta readMetadataMetaVersion3(xml.XmlElement metadataMetaNode) {
    String? id;
    String? refines;
    String? property;
    String? scheme;

    metadataMetaNode.attributes.forEach((xml.XmlAttribute metadataMetaNodeAttribute) {
      final attributeValue = metadataMetaNodeAttribute.value;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
          break;
        case 'refines':
          refines = attributeValue;
          break;
        case 'property':
          property = attributeValue;
          break;
        case 'scheme':
          scheme = attributeValue;
          break;
      }
    });

    return EpubMetadataMeta(
      name: null,
      content: metadataMetaNode.text,
      id: id,
      refines: refines,
      property: property,
      scheme: scheme,
    );
  }

  static Future<EpubPackage> readPackage(Archive epubArchive, String rootFilePath) async {
    final rootFileEntry = epubArchive.files.firstWhereOrNull((ArchiveFile testfile) => testfile.name == rootFilePath);
    if (rootFileEntry == null) {
      throw Exception('EPUB parsing error: root file not found in archive.');
    }
    final containerDocument = xml.XmlDocument.parse(convert.utf8.decode(rootFileEntry.content));
    final opfNamespace = 'http://www.idpf.org/2007/opf';
    final packageNode = containerDocument.findElements('package', namespace: opfNamespace).firstOrNull;

    final EpubVersion version;
    final EpubMetadata metadata;
    final EpubManifest manifest;
    final EpubSpine spine;
    final EpubGuide? guide;

    final epubVersionValue = packageNode?.getAttribute('version');
    if (epubVersionValue == '2.0') {
      version = EpubVersion.Epub2;
    } else if (epubVersionValue == '3.0') {
      version = EpubVersion.Epub3;
    } else {
      throw Exception('Unsupported EPUB version: $epubVersionValue.');
    }

    final metadataNode = packageNode?.findElements('metadata', namespace: opfNamespace).firstOrNull;
    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }
    metadata = readMetadata(metadataNode, version);

    final manifestNode = packageNode?.findElements('manifest', namespace: opfNamespace).firstOrNull;
    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }
    manifest = readManifest(manifestNode);

    final spineNode = packageNode?.findElements('spine', namespace: opfNamespace).firstOrNull;
    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }
    spine = readSpine(spineNode);

    final guideNode = packageNode?.findElements('guide', namespace: opfNamespace).firstOrNull;
    if (guideNode != null) {
      guide = readGuide(guideNode);
    } else {
      guide = null;
    }

    return EpubPackage(
      version: version,
      metadata: metadata,
      manifest: manifest,
      spine: spine,
      guide: guide,
    );
  }

  static EpubSpine readSpine(xml.XmlElement spineNode) {
    List<EpubSpineItemRef> items = [];
    spineNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement spineItemNode) {
      if (spineItemNode.name.local.toLowerCase() == 'itemref') {
        final idRefAttribute = spineItemNode.getAttribute('idref');
        if (idRefAttribute == null || idRefAttribute.isEmpty) {
          throw Exception('Incorrect EPUB spine: item ID ref is missing');
        }
        final linearAttribute = spineItemNode.getAttribute('linear');
        final isLinear = linearAttribute == null || (linearAttribute.toLowerCase() == 'no');

        final spineItemRef = EpubSpineItemRef(idRef: idRefAttribute, isLinear: isLinear);
        items.add(spineItemRef);
      }
    });

    return EpubSpine(
      tableOfContents: spineNode.getAttribute('toc'),
      items: items,
    );
  }
}
