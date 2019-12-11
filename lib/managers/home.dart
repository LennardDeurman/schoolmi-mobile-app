import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/auth/login_refresh_manager.dart';
import 'package:schoolmi/managers/profile.dart';
import 'dart:async';

enum InitializationResult {
  idle,
  ready,
  serverConnectionError,
  noChannelAvailable,
}

class HomeManager extends BaseManager {

  final LoginRefreshManager loginRefreshManager = new LoginRefreshManager();

  ProfileManager _profileManager;


  HomeManager () {
    _profileManager = new ProfileManager(this);
  }


  ProfileManager get profileManager {
    return _profileManager;
  }

  Future<InitializationResult> initialize() async {
    Completer<InitializationResult> completer = new Completer();
    refreshData(forceRefresh: false).then((_) {
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

  Future refreshData({ bool forceRefresh = true }) async {
    await loginRefreshManager.refreshData(
      refreshProfile: !UserService().loginResult.profileResult.retrievedOnline || forceRefresh,
      refreshMyChannels: !UserService().loginResult.profileResult.retrievedOnline || forceRefresh
    );
  }

}
