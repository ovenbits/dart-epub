import 'package:quiver/core.dart';

class EpubMetadataMeta {
  EpubMetadataMeta({
    this.name,
    this.content,
    this.id,
    this.refines,
    this.property,
    this.scheme,
  });

  String? name;
  String? content;
  String? id;
  String? refines;
  String? property;
  String? scheme;

  @override
  int get hashCode => hashObjects([
        name.hashCode,
        content.hashCode,
        id.hashCode,
        refines.hashCode,
        property.hashCode,
        scheme.hashCode,
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataMeta?;
    if (otherAs == null) return false;
    return name == otherAs.name && content == otherAs.content && id == otherAs.id && refines == otherAs.refines && property == otherAs.property && scheme == otherAs.scheme;
  }
}
