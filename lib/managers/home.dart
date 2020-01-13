import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/managers/profile.dart';
import 'dart:async';
import 'package:schoolmi/network/parsers/questions.dart';

enum InitializationResult {
  idle,
  ready,
  serverConnectionError,
  noChannelAvailable,
}

class HomeManager extends BaseManager {

  ProfileManager _profileManager;

  QuestionsParser questionsParser; //To be set by layout

  HomeManager () {
    _profileManager = new ProfileManager(this);
  }


  ProfileManager get profileManager {
    return _profileManager;
  }

  Future<InitializationResult> initialize() async {
    Completer<InitializationResult> completer = new Completer();

    executeAsync(Future.wait([downloadProfile(), downloadChannels()]).then((_) {
      if (UserService().loginResult.hasActiveChannel) {
        completer.complete(InitializationResult.ready);
      } else {
        completer.complete(InitializationResult.noChannelAvailable);
      }
    }).catchError((e) {
      if (!UserService().loginResult.hasActiveChannel) {
        completer.complete(InitializationResult.serverConnectionError);
      }
    }));

    return completer.future;

  }

  Future downloadProfile() {
    return UserService().profileParser.download().then((result) {
      UserService().loginResult.profileResult = result;
    });
  }

  Future downloadChannels() {
    return UserService().myChannelsParser.download().then((result) {
      UserService().loginResult.myChannelsResult = result;
    });
  }

  Future leaveChannel() {
    var channels = UserService().loginResult.channels.where((Channel channel) {
      return !UserService().loginResult.isActiveChannel(channel);
    });
    Channel newActiveChannel;
    if (channels.length > 0) {
      newActiveChannel = channels.first;
    }
    UserService().loginResult.myChannelsResult.objects = channels;
    int currentActiveChannelId = UserService().loginResult.activeChannel.id;
    switchToChannel(newActiveChannel);
    return Api.leaveChannel(channelId: currentActiveChannelId);
  }

  void switchToChannel(Channel channel) {
    UserService().loginResult.activeChannel = channel;
    notifyListeners();
  }





}
