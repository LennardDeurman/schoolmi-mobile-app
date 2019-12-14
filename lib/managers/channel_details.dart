import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/managers/tags.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'dart:async';

class ChannelDetailsChildManager extends ChildManager {

  NetworkParser parser;

  StreamController<Channel> _channelStreamController = new StreamController<Channel>();

  ChannelDetailsChildManager (HomeManager homeManager) : super(homeManager) {
    _channelStreamController.onCancel = () {
      _channelStreamController.close();
    };
  }

  void subscribeToEvents() {
    if (_channel != null) {
      _channelStreamController.add(_channel);
    }
  }

  void onChannelLoad(Channel channel){}

  Stream<Channel> get channelStream  {
    return _channelStreamController.stream;
  }

  Channel _channel;

  set channel (Channel channel) {
    _channel = channel;
    _channelStreamController.add(channel);
    onChannelLoad(channel);
  }

  Channel get channel {
    return _channel;
  }

  @override
  bool get isLoading {
    if (parser == null) {
      return true;
    } else if (parser.downloadStatusInfo.downloadStatus == DownloadStatus.downloading) {
      return true;
    }
    return super.isLoading;
  }


}

class ChannelDetailsManager extends ChildManager {

  MembersManager membersManager;
  TagsManager tagsManager;

  ChannelDetailsManager (HomeManager homeManager) : super(homeManager) {
    membersManager = new MembersManager(homeManager);
    tagsManager = new TagsManager(homeManager);
  }

  @override
  void loadData() {
    var loginResult = UserService().loginResult;
    Channel channel;
    if (loginResult != null) {
      channel = loginResult.activeChannel;
    }
    membersManager.channel = channel;
    tagsManager.channel = channel;
  }

}

