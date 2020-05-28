import 'dart:convert';

import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:http/http.dart' as http;

class RolesParser extends ChannelBaseNetworkParser with ParserWithQueryInfo {

  int questionId;

  RolesParser (Channel channel) : super(channel);

  @override
  Map<String, dynamic> toPostDictionary(List<BaseObject> uploadObjects) {
    return makeMultiObjectsDictionary(Keys().roles, uploadObjects);
  }

  @override
  List<BaseObject> objectsFromPostResponse(List<BaseObject> uploadedObjects, http.Response response) {
    Map<String, dynamic> dictionary = json.decode(response.body);
    Map<String, dynamic> objectDict = dictionary[Keys().object];
    return ParsableObject.parseObjectsList(objectDict, Keys().results, toObject: toObject);
  }

  @override
  String get downloadUrl {
    return Urls.roles(channelId: channel.id, queryInfo: queryInfo);
  }

  @override
  String get uploadUrl {
    return Urls.roles(channelId: channel.id);
  }

  @override
  BaseObject toObject(Map dictionary) {
    return Role(dictionary);
  }
}