import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_doc_author.dart';
import 'epub_navigation_doc_title.dart';
import 'epub_navigation_head.dart';
import 'epub_navigation_list.dart';
import 'epub_navigation_map.dart';
import 'epub_navigation_page_list.dart';

class EpubNavigation {
  EpubNavigation({
    required this.head,
    required this.docTitle,
    required this.docAuthors,
    required this.navMap,
    required this.pageList,
    required this.navLists,
  });

  factory EpubNavigation.empty() => EpubNavigation(
        head: EpubNavigationHead(metadata: []),
        docTitle: EpubNavigationDocTitle(titles: []),
        docAuthors: [],
        navMap: EpubNavigationMap(points: []),
        pageList: null,
        navLists: [],
      );

  final EpubNavigationHead head;
  final EpubNavigationDocTitle docTitle;
  final List<EpubNavigationDocAuthor> docAuthors;
  final EpubNavigationMap navMap;
  final EpubNavigationPageList? pageList;
  final List<EpubNavigationList> navLists;

  @override
  int get hashCode {
    final objects = [
      head.hashCode,
      docTitle.hashCode,
      navMap.hashCode,
      pageList.hashCode,
      ...docAuthors.map((author) => author.hashCode),
      ...navLists.map((navList) => navList.hashCode),
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigation?;
    if (otherAs == null) {
      return false;
    }

    if (!collections.listsEqual(docAuthors, otherAs.docAuthors)) {
      return false;
    }
    if (!collections.listsEqual(navLists, otherAs.navLists)) {
      return false;
    }

    return head == otherAs.head && docTitle == otherAs.docTitle && navMap == otherAs.navMap && pageList == otherAs.pageList;
  }
}
