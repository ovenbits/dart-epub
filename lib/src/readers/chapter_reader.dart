import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/navigation/epub_navigation_point.dart';

class ChapterReader {
  static List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
    if (bookRef.schema.navigation == null) {
      return [];
    }
    return getChaptersImpl(bookRef, bookRef.schema.navigation!.navMap.points);
  }

  static List<EpubChapterRef> getChaptersImpl(EpubBookRef bookRef, List<EpubNavigationPoint> navigationPoints) {
    List<EpubChapterRef> result = [];
    navigationPoints.forEach((EpubNavigationPoint navigationPoint) {
      String contentFileName;
      String? anchor;
      int contentSourceAnchorCharIndex = navigationPoint.content.source.indexOf('#');
      if (contentSourceAnchorCharIndex == -1) {
        contentFileName = navigationPoint.content.source;
        anchor = null;
      } else {
        contentFileName = navigationPoint.content.source.substring(0, contentSourceAnchorCharIndex);
        anchor = navigationPoint.content.source.substring(contentSourceAnchorCharIndex + 1);
      }

      EpubTextContentFileRef htmlContentFileRef;
      if (!bookRef.content.html.containsKey(contentFileName)) {
        contentFileName = Uri.decodeFull(contentFileName);
        if (!bookRef.content.html.containsKey(contentFileName)) {
          throw Exception('Incorrect EPUB manifest: item with href = \"$contentFileName\" is missing.');
        }
      }

      htmlContentFileRef = bookRef.content.html[contentFileName]!;
      EpubChapterRef chapterRef = EpubChapterRef(
        epubTextContentFileRef: htmlContentFileRef,
        title: navigationPoint.navigationLabels.first.text,
        contentFileName: contentFileName,
        anchor: anchor,
        subChapters: getChaptersImpl(bookRef, navigationPoint.childNavigationPoints),
      );

      result.add(chapterRef);
    });
    return result;
  }
}
