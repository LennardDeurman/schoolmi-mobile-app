import 'package:schoolmi/network/models/abstract/content_child_object.dart';
import 'package:schoolmi/network/models/settings/event_preferences.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';

class ContentFollower extends ContentChildObject {

  int overriddenEventPreferencesId;
  EventPreferences overriddenEventPreferences;

  ContentFollower (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);

    overriddenEventPreferencesId = dictionary[Keys().overriddenEventPreferencesId];
    overriddenEventPreferences = ParsableObject.parseObject(dictionary[Keys().overriddenEventPreferences], objectCreator: (Map<String, dynamic> dict) {
      return EventPreferences(dict);
    });
  }

  @override
  Map<String, dynamic> toDictionary() {
    var dict = super.toDictionary();
    dict.addAll({
      Keys().overriddenEventPreferences: overriddenEventPreferences.toDictionary(),
      Keys().overriddenEventPreferencesId: overriddenEventPreferencesId
    });
    return dict;
  }
}
