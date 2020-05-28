
import 'dart:convert';

import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/network/channel_base_parser.dart';

import 'package:http/http.dart' as http;
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/tag.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/channel.dart';

class TagsParser extends ChannelBaseNetworkParser with ParserWithQueryInfo {


  TagsParser (Channel channel) : super(channel);

  @override
  String get downloadUrl {
    return Urls.tags(channelId: channel.id, queryInfo: queryInfo);
  }

  @override
  String get uploadUrl {
    return Urls.tags(channelId: channel.id);
  }

  @override
  List<BaseObject> objectsFromPostResponse(List<BaseObject> uploadedObjects, http.Response response) {
    Map<String, dynamic> dictionary = json.decode(response.body);
    Map<String, dynamic> objectDict = dictionary[Keys().object];
    return ParsableObject.parseObjectsList(objectDict, Keys().results, toObject: toObject);
  }

  @override
  Map<String, dynamic> toPostDictionary(List<BaseObject> uploadObjects) {
    return makeMultiObjectsDictionary(Keys().tags, uploadObjects);
  }

  @override
  BaseObject toObject(Map dictionary) {
    return Tag(dictionary);
  }


}