import 'package:schoolmi/managers/channel_details.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/managers/upload_interface.dart';
import 'package:schoolmi/models/data/tag.dart';
import 'package:schoolmi/network/parsers/tags.dart';

class TagsManager extends ChannelDetailsChildManager with UploadInterface<Tag> {

  TagsManager (HomeManager homeManager) : super(homeManager);

  @override
  void onChannelLoad(Channel channel) {
    parser = TagsParser(channel);
    notifyListeners();
  }

  @override
  Future<List<Tag>> saveUploadObjects() {
    return executeAsync<List<Tag>>(wrapUpload(performUpload(parser)));
  }

  bool isQueryValid() {
    TagsParser parser = this.parser;
    if (parser.queryInfo != null) {
      if (parser.queryInfo.search != null && parser.queryInfo.search.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

}