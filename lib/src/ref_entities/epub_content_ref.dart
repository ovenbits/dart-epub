import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef {
  EpubContentRef({
    Map<String, EpubTextContentFileRef>? html,
    Map<String, EpubTextContentFileRef>? css,
    Map<String, EpubByteContentFileRef>? images,
    Map<String, EpubByteContentFileRef>? fonts,
    Map<String, EpubContentFileRef>? allFiles,
  })  : this.html = html ?? {},
        this.css = css ?? {},
        this.images = images ?? {},
        this.fonts = fonts ?? {},
        this.allFiles = allFiles ?? {};

  final Map<String, EpubTextContentFileRef> html;
  final Map<String, EpubTextContentFileRef> css;
  final Map<String, EpubByteContentFileRef> images;
  final Map<String, EpubByteContentFileRef> fonts;
  final Map<String, EpubContentFileRef> allFiles;

  @override
  int get hashCode {
    final objects = [
      ...html.keys.map((key) => key.hashCode),
      ...html.values.map((value) => value.hashCode),
      ...css.keys.map((key) => key.hashCode),
      ...css.values.map((value) => value.hashCode),
      ...images.keys.map((key) => key.hashCode),
      ...images.values.map((value) => value.hashCode),
      ...fonts.keys.map((key) => key.hashCode),
      ...fonts.values.map((value) => value.hashCode),
      ...allFiles.keys.map((key) => key.hashCode),
      ...allFiles.values.map((value) => value.hashCode),
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubContentRef?;
    if (otherAs == null) {
      return false;
    }

    return collections.mapsEqual(html, otherAs.html) && collections.mapsEqual(css, otherAs.css) && collections.mapsEqual(images, otherAs.images) && collections.mapsEqual(fonts, otherAs.fonts) && collections.mapsEqual(allFiles, otherAs.allFiles);
  }
}
