import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/models/data/channel.dart';
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



    UserService().refreshData(forceRefresh: true).then((_) {
      if (UserService().hasActiveChannel) {
        completer.complete(InitializationResult.ready);
      } else {
        completer.complete(InitializationResult.noChannelAvailable);
      }
    }).catchError((e) {

      // An error occured in the server connection (for example user is offline). The app is usable if and only if the active channel is already present.

      if (!UserService().hasActiveChannel) {
        completer.complete(InitializationResult.serverConnectionError);
      }

    });

    return completer.future.whenComplete(() {
      notifyListeners();
    });
  }

  Future switchToChannel(Channel channel) {

  }

  Future leaveChannel() {

  }


}
