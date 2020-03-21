import 'dart:async';

import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/managers/tags.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/models/data/channel.dart';

class ChannelDetailsChildManager extends ChildManager {

  NetworkParser parser;

  ChannelDetailsChildManager (HomeManager homeManager) : super(homeManager);

  Channel _channel;

  void onChannelLoad(Channel channel) {

  }

  set channel (Channel channel) {
    _channel = channel;
    onChannelLoad(channel);
    notifyListeners();
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

    UserService().loginResult.onChannelChange.listen((Channel channel) {
      loadData();
    });

  }

  @override
  void initialize() {
    super.initialize();

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

