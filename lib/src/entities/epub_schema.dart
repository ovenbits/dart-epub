import 'package:quiver/core.dart';

import '../schema/navigation/epub_navigation.dart';
import '../schema/opf/epub_package.dart';

class EpubSchema {
  EpubSchema({
    required this.package,
    required this.navigation,
    required this.contentDirectoryPath,
  });

  factory EpubSchema.empty() => EpubSchema(
        package: EpubPackage.empty(),
        navigation: null,
        contentDirectoryPath: '',
      );

  EpubPackage package;
  EpubNavigation? navigation;
  String contentDirectoryPath;

  @override
  int get hashCode => hash3(package.hashCode, navigation.hashCode, contentDirectoryPath.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubSchema?;
    if (otherAs == null) {
      return false;
    }

    return package == otherAs.package && navigation == otherAs.navigation && contentDirectoryPath == otherAs.contentDirectoryPath;
  }
}
