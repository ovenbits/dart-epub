import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file.dart';
import 'epub_content_file.dart';
import 'epub_text_content_file.dart';

class EpubContent {
  EpubContent({
    Map<String, EpubTextContentFile>? html,
    Map<String, EpubTextContentFile>? css,
    Map<String, EpubByteContentFile>? images,
    Map<String, EpubByteContentFile>? fonts,
    Map<String, EpubContentFile>? allFiles,
  })  : this.html = html ?? {},
        this.css = css ?? {},
        this.images = images ?? {},
        this.fonts = fonts ?? {},
        this.allFiles = allFiles ?? {};

  final Map<String, EpubTextContentFile> html;
  final Map<String, EpubTextContentFile> css;
  final Map<String, EpubByteContentFile> images;
  final Map<String, EpubByteContentFile> fonts;
  final Map<String, EpubContentFile> allFiles;

  @override
  int get hashCode {
    var objects = [
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
    var otherAs = other as EpubContent?;
    if (otherAs == null) {
      return false;
    }

    return collections.mapsEqual(html, otherAs.html) && collections.mapsEqual(css, otherAs.css) && collections.mapsEqual(images, otherAs.images) && collections.mapsEqual(fonts, otherAs.fonts) && collections.mapsEqual(allFiles, otherAs.allFiles);
  }
}
