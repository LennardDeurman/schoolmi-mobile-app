import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_default_props.dart';


abstract class BaseObject with ParsableObject, ObjectWithDefaultProps  {

  int id;

  final Map<String, dynamic> dictionary;

  BaseObject (this.dictionary)  {
    parse(this.dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    parseDefaultProps(dictionary);
    this.id = dictionary[Keys().id];
  }

  @override
  bool operator ==(other) {
    if (other is BaseObject) {
      return other.id == this.id && other.id != null;
    }
    return false;
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().deleted: isDeleted,
      Keys().id: id,
      Keys().dateAdded: Dates.format(dateAdded),
      Keys().dateModified: Dates.format(dateModified)
    };
  }



}