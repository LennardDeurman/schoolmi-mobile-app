import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:http/http.dart' as http;

class MembersParser extends ChannelBaseNetworkParser with ParserWithQueryInfo {

  MembersParser (Channel channel) : super(channel);

  @override
  String get downloadUrl {
    return Urls.members(channelId: channel.id);
  }

  @override
  String get uploadUrl {
    return Urls.members(channelId: channel.id);
  }

  @override
  Map<String, dynamic> toPostDictionary(List<BaseObject> uploadObjects) {
    return makeMultiObjectsDictionary(Keys.members, uploadObjects);
  }

  @override
  List<BaseObject> objectsFromPostResponse(List<BaseObject> uploadedObjects, http.Response response) {
    //Endpoint doesn't return objects nor ids
    return uploadedObjects;
  }
}