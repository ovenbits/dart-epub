import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:epub/epub.dart';
import 'package:epub/src/utils/zip_path_utils.dart';
import 'package:epub/src/writers/epub_package_writer.dart';

class EpubWriter {
  static const _container_file = '<?xml version="1.0"?><container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container"><rootfiles><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/></rootfiles></container>';

  // Creates a Zip Archive of an EpubBook
  static Archive _createArchive(EpubBook book) {
    var arch = Archive();

    // Add simple metadata
    arch.addFile(ArchiveFile.noCompress('metadata', 20, convert.utf8.encode('application/epub+zip')));

    // Add Container file
    arch.addFile(ArchiveFile('META-INF/container.xml', _container_file.length, convert.utf8.encode(_container_file)));

    // Add all content to the archive
    book.content.allFiles.forEach((name, file) {
      List<int> content;

      if (file is EpubByteContentFile) {
        content = file.content;
      } else if (file is EpubTextContentFile) {
        content = convert.utf8.encode(file.content);
      } else {
        content = [];
      }

      arch.addFile(ArchiveFile(ZipPathUtils.combine(book.schema.contentDirectoryPath, name), content.length, content));
    });

    // Generate the content.opf file and add it to the Archive
    var contentopf = EpubPackageWriter.writeContent(book.schema.package);

    arch.addFile(ArchiveFile(ZipPathUtils.combine(book.schema.contentDirectoryPath, 'content.opf'), contentopf.length, convert.utf8.encode(contentopf)));

    return arch;
  }

  // Serializes the EpubBook into a byte array
  static List<int>? writeBook(EpubBook book) {
    var arch = _createArchive(book);

    return ZipEncoder().encode(arch);
  }
}
