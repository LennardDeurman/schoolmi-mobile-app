import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/extensions/dates.dart';

class ObjectWithDefaultProps {

  bool isDeleted;
  DateTime dateModified;
  DateTime dateAdded;

  void parseDefaultProps(Map<String, dynamic> dictionary) {

      dateModified = ParsableObject.parseDate(dictionary[Keys().dateModified]);
      dateAdded = ParsableObject.parseDate(dictionary[Keys().dateAdded]);
      isDeleted = ParsableObject.parseBool(dictionary[Keys().deleted]);

  }

  Map<String, dynamic> defaultPropsDictionary() {
    return {
      Keys().deleted: isDeleted,
      Keys().dateModified: Dates.format(dateModified),
      Keys().dateAdded: Dates.format(dateAdded)
    };
  }
}