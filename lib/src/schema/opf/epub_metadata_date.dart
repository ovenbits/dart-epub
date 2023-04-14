import 'package:quiver/core.dart';

class EpubMetadataDate {
  EpubMetadataDate({required this.date, required this.event});

  factory EpubMetadataDate.empty() => EpubMetadataDate(date: '', event: null);

  String date;
  String? event;

  @override
  int get hashCode => hash2(date.hashCode, event.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataDate?;
    if (otherAs == null) return false;
    return date == otherAs.date && event == otherAs.event;
  }
}
