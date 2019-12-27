import 'package:sprintf/sprintf.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/localization/login.dart';
import 'package:schoolmi/localization/global.dart';
import 'package:schoolmi/localization/actions.dart';
import 'package:schoolmi/localization/reporting.dart';
import 'package:schoolmi/localization/channels.dart';
import 'package:schoolmi/localization/errors.dart';
import 'package:schoolmi/localization/expressions.dart';
import 'package:schoolmi/localization/questions.dart';
import 'package:schoolmi/localization/files.dart';
import 'package:schoolmi/localization/members.dart';
import 'package:schoolmi/localization/profile.dart';
import 'package:schoolmi/localization/pages.dart';

class Languages {
  static const String NL = "nl";
  static const String DE = "de";
  static const String EN = "en";
  static const String FR = "fr";

  static String localeForKey(String key) {
    return key; //Might need some fixes if other languages are supported
  }
}

class Localization with LoginLocalization,  GlobalLocalization, ProfileLocalization, ReportingLocalization, PagesLocalization, ActionsLocalization, MembersLocalization, FilesLocalization, ChannelsLocalization, ErrorsLocalization, Expressions, QuestionsLocalization {


  String _languageKey;

  static final Localization _instance = Localization._internal();

  factory Localization () {
    return _instance;
  }

  Localization._internal() {
    _languageKey = Languages.NL; //When we are gone support localization this can be changed to something like load from prefs
  }

  String get locale {
    return Languages.localeForKey(_languageKey);
  }


  String capitalize(String input)  {
    return (input != null && input.length > 1)
        ? input[0].toUpperCase() + input.substring(1)
        : input != null ? input.toUpperCase() : null;
  }

  String buildIndexString(String noun, int index, int maxIndex) {
    return "$noun $index/$maxIndex";
  }

  String buildUsersString(List<Profile> profiles, { int maxUsersLength = 10} ) {
    if (profiles.length == 2) {
      String firstUser = profiles[0].fullName;
      String secondUser = profiles[0].fullName;
      String andValue = and.getValue(_languageKey);
      return "$firstUser $andValue $secondUser";
    }
    if (profiles.length > maxUsersLength) {
      int othersCount = (profiles.length - maxUsersLength);
      String usersStr = profiles.sublist(0, maxUsersLength).map((Profile profile){
        return profile.fullName;
      }).join(", ");
      return sprintf(otherUsers.getValue(_languageKey), [usersStr, othersCount]);
    } else {
      return profiles.map((Profile profile){
        return profile.fullName;
      }).join(", ");
    }
  }

  String buildWithParams(LocalizationObject object, var args) {
    String value = object.getValue(_languageKey);
    return sprintf(value, args);
  }

  String buildNumberAndText(LocalizationObject object, {int count, bool excludeNumber = false, bool capitalizeFirst = true}) {
    if (count == null) {
      count = 0;
    }
    
    String form = object.getValue(_languageKey, usePluralForm: count == 0 || count > 1);
    if (form.length > 1) {
      form = (capitalizeFirst ? form[0].toUpperCase() : form[1].toLowerCase()) + form.substring(1);
    }
    if (excludeNumber) {
      return form;
    }
    return "$count $form";
  }

  String getValue(LocalizationObject object, {bool usePluralForm = false}) {
    return object.getValue(_languageKey, usePluralForm: usePluralForm);
  }
}

class NonTranslateAbleObject extends LocalizationObject {

  final String value;

  NonTranslateAbleObject (this.value) : super(null);

  @override
  String getValue(String languageKey, {bool usePluralForm = false}) {
    return value;
  }

}

class NounForm {

  final String plural;
  final String singular;

  NounForm ({this.plural, this.singular});

}

class LocalizationObject {

  final Map<String, dynamic> languageMap;


  LocalizationObject (this.languageMap);


  String getValue(String languageKey, {bool usePluralForm = false}) {
    if (languageMap.containsKey(languageKey)) {
      var value = languageMap[languageKey];
      if (value is String) {
        return value;
      } else if (value is NounForm) {
         return usePluralForm ? value.plural : value.singular;
      }
    } else {
      throw new LocalizationException("Not localization provided for value " + languageKey);
    }
    return null;
  }

}


