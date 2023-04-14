import '../entities/epub_content_type.dart';
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../ref_entities/epub_content_file_ref.dart';
import '../ref_entities/epub_content_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';

class ContentReader {
  static EpubContentRef parseContentMap(EpubBookRef bookRef) {
    Map<String, EpubTextContentFileRef> html = {};
    Map<String, EpubTextContentFileRef> css = {};
    Map<String, EpubByteContentFileRef> images = {};
    Map<String, EpubByteContentFileRef> fonts = {};
    Map<String, EpubContentFileRef> allFiles = {};

    bookRef.schema.package.manifest.items.forEach((EpubManifestItem manifestItem) {
      String fileName = manifestItem.href;
      String contentMimeType = manifestItem.mediaType;
      EpubContentType contentType = getContentTypeByContentMimeType(contentMimeType);
      switch (contentType) {
        case EpubContentType.XHTML_1_1:
        case EpubContentType.CSS:
        case EpubContentType.OEB1_DOCUMENT:
        case EpubContentType.OEB1_CSS:
        case EpubContentType.XML:
        case EpubContentType.DTBOOK:
        case EpubContentType.DTBOOK_NCX:
          final epubTextContentFile = EpubTextContentFileRef(
            epubBookRef: bookRef,
            fileName: Uri.decodeFull(fileName),
            contentMimeType: contentMimeType,
            contentType: contentType,
          );

          switch (contentType) {
            case EpubContentType.XHTML_1_1:
              html[fileName] = epubTextContentFile;
              break;
            case EpubContentType.CSS:
              css[fileName] = epubTextContentFile;
              break;
            case EpubContentType.DTBOOK:
            case EpubContentType.DTBOOK_NCX:
            case EpubContentType.OEB1_DOCUMENT:
            case EpubContentType.XML:
            case EpubContentType.OEB1_CSS:
            case EpubContentType.IMAGE_GIF:
            case EpubContentType.IMAGE_JPEG:
            case EpubContentType.IMAGE_PNG:
            case EpubContentType.IMAGE_SVG:
            case EpubContentType.FONT_TRUETYPE:
            case EpubContentType.FONT_OPENTYPE:
            case EpubContentType.OTHER:
              break;
          }
          allFiles[fileName] = epubTextContentFile;
          break;
        default:
          final epubByteContentFile = EpubByteContentFileRef(
            epubBookRef: bookRef,
            fileName: Uri.decodeFull(fileName),
            contentMimeType: contentMimeType,
            contentType: contentType,
          );

          switch (contentType) {
            case EpubContentType.IMAGE_GIF:
            case EpubContentType.IMAGE_JPEG:
            case EpubContentType.IMAGE_PNG:
            case EpubContentType.IMAGE_SVG:
              images[fileName] = epubByteContentFile;
              break;
            case EpubContentType.FONT_TRUETYPE:
            case EpubContentType.FONT_OPENTYPE:
              fonts[fileName] = epubByteContentFile;
              break;
            case EpubContentType.CSS:
            case EpubContentType.XHTML_1_1:
            case EpubContentType.DTBOOK:
            case EpubContentType.DTBOOK_NCX:
            case EpubContentType.OEB1_DOCUMENT:
            case EpubContentType.XML:
            case EpubContentType.OEB1_CSS:
            case EpubContentType.OTHER:
              break;
          }
          allFiles[fileName] = epubByteContentFile;
          break;
      }
    });

    return EpubContentRef(
      html: html,
      css: css,
      images: images,
      fonts: fonts,
      allFiles: allFiles,
    );
  }

  static EpubContentType getContentTypeByContentMimeType(String contentMimeType) {
    switch (contentMimeType.toLowerCase()) {
      case 'application/xhtml+xml':
        return EpubContentType.XHTML_1_1;
      case 'application/x-dtbook+xml':
        return EpubContentType.DTBOOK;
      case 'application/x-dtbncx+xml':
        return EpubContentType.DTBOOK_NCX;
      case 'text/x-oeb1-document':
        return EpubContentType.OEB1_DOCUMENT;
      case 'application/xml':
        return EpubContentType.XML;
      case 'text/css':
        return EpubContentType.CSS;
      case 'text/x-oeb1-css':
        return EpubContentType.OEB1_CSS;
      case 'image/gif':
        return EpubContentType.IMAGE_GIF;
      case 'image/jpeg':
        return EpubContentType.IMAGE_JPEG;
      case 'image/png':
        return EpubContentType.IMAGE_PNG;
      case 'image/svg+xml':
        return EpubContentType.IMAGE_SVG;
      case 'font/truetype':
        return EpubContentType.FONT_TRUETYPE;
      case 'font/opentype':
        return EpubContentType.FONT_OPENTYPE;
      case 'application/vnd.ms-opentype':
        return EpubContentType.FONT_OPENTYPE;
      default:
        return EpubContentType.OTHER;
    }
  }
}
