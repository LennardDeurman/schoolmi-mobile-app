import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/profile.dart';

typedef ParseObjectCallback = BaseObject Function(Map dictionary);

abstract class BaseObject with ParsableObject  {

  bool isDeleted;
  int id;
  DateTime dateAdded;
  DateTime dateModified;
  Profile profile;

  final Map<String, dynamic> dictionary;

  BaseObject (this.dictionary)  {
    parse(this.dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    var profileDictionary = dictionary[Keys.user];
    if (profileDictionary != null) {
      profile = Profile(profileDictionary);
    }
    id = dictionary[Keys.id];
    dateAdded = Dates.parse(dictionary[Keys.dateAdded]);
    dateModified = Dates.parse(dictionary[Keys.dateModified]);
    isDeleted = ParsableObject.parseBool(dictionary[Keys.deleted]);
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
      Keys.deleted: isDeleted,
      Keys.id: id,
      Keys.dateAdded: Dates.format(dateAdded),
      Keys.dateModified: Dates.format(dateModified),
      Keys.user: profile != null ? profile.toDictionary() : null
    };
  }



}