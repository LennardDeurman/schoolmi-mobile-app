
import 'package:schoolmi/network/parsers/abstract/network_parser.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/network/cache_manager.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/parsing_result.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileParser extends NetworkParser {

  ProfileParser () : super();

  @override
  String get downloadUrl {
    return Urls.profile;
  }

  @override
  String get uploadUrl {
    return Urls.profile;
  }

  @override
  List<BaseObject> objectsFromPostResponse(List<BaseObject> uploadedObjects, http.Response response) {
    return objectsFromResponse(response);
  }


  Future<ParsingResult> loadCachedData() async {
    return CacheManager.loadCache(CacheManager.myProfile, toObject: (Map dictionary) {
      return Profile(dictionary);
    });
  }

  @override
  List<BaseObject> objectsFromResponse(http.Response response) {
    final body = json.decode(response.body)[Keys().object];
    final profileDict = body[Keys().profile];
    if (profileDict != null) {
      List<Profile> objects = [Profile(profileDict)];
      CacheManager.save(CacheManager.myProfile, objects);
      return objects;
    }
    return List<Profile>();
  }

  @override
  BaseObject toObject(Map dictionary) {
    return Profile(dictionary);
  }

}