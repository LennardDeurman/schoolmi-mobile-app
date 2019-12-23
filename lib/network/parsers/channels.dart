import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/network/cache_manager.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:http/http.dart' as http;


class ChannelsParser extends NetworkParser with ParserWithQueryInfo {

  bool showOpenChannels;

  ChannelsParser ({this.showOpenChannels = false}) : super();

  @override
  String get downloadUrl {
    return showOpenChannels ? Urls.publicChannels(queryInfo: queryInfo) : Urls.channels;
  }

  @override
  String get uploadUrl {
    return Urls.channels;
  }

  @override
  Future<ParsingResult> loadCachedData() async {
    if (!showOpenChannels && isQueryInfoEmpty()) {
      return CacheManager.loadCache(CacheManager.myChannels, toObject: (Map dictionary) {
        return Channel(dictionary);
      });
    }
    return super.loadCachedData();
  }

  @override
  List<BaseObject> objectsFromResponse(http.Response response) {
    List<BaseObject> objectsFromServer = super.objectsFromResponse(response);
    if (!showOpenChannels && isQueryInfoEmpty()) {
      CacheManager.save(CacheManager.myChannels, objectsFromServer);
    }
    return objectsFromServer;
  }

  @override
  BaseObject toObject(Map dictionary) {
    return Channel(dictionary);
  }

}