import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheManager {

  static const String myChannels = "myChannels";
  static const String myProfile = "myProfile";

  static Future save(String key, List<BaseObject> objects) async {
    Map<String, dynamic> cacheObject = {
      Keys.results: objects.map((BaseObject baseObject) {
        return baseObject.toDictionary();
      }),
      Keys.dateModified: Dates.format(DateTime.now())
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, json.encode(cacheObject));
  }

  static Future<ParsingResult> loadCache(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonStr = sharedPreferences.get(key);
    if (jsonStr != null) {
      Map<String, dynamic> cacheObject = json.decode(jsonStr);
      return ParsingResult.fromCacheDictionary(cacheObject);
    }
    return null;
  }

  static Future deleteAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

}