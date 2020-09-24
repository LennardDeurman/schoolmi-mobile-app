

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/keys.dart';

abstract class CacheProtocol<T extends ParsableObject> {

  T toObject(Map<String, dynamic> map);

  String get key;

  Future save(List<T> objects) async {
    Map<String, dynamic> cacheObject = {
      Keys().results: objects.map((T object) {
        return object.toDictionary();
      }).toList(),
      Keys().dateModified: Dates.format(DateTime.now())
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(this.key, json.encode(cacheObject));
  }

  Future<FetchResult<T>> load() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonStr = sharedPreferences.get(this.key);
    if (jsonStr != null) {
      Map<String, dynamic> cacheObject = json.decode(jsonStr);
      FetchResult<T> fetchResult = FetchResult<T>.fromCacheDictionary(cacheObject, toObject: toObject);
      return fetchResult;
    }
    return null;
  }

}

class MyChannelsCacheProtocol extends CacheProtocol<Channel> {

  String get key {
    return "myChannels";
  }

  @override
  Channel toObject(Map<String, dynamic> map) {
    return Channel(map);
  }

}

class ProfileCacheProtocol extends CacheProtocol<Profile> {

  String get key {
    return "profile";
  }

  @override
  Profile toObject(Map<String, dynamic> map) {
    return Profile(map);
  }
}