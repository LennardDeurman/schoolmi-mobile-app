import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/network/auth/user_service.dart';

enum InitializationResult {
  idle,
  ready,
  serverConnectionError,
  noChannelAvailable,
}

class HomeManager extends BaseManager {

  UserEventsHandler userEventsHandler;

  HomeManager () {
    userEventsHandler = UserEventsHandler(
      onActiveChannelChange: () {
        notifyListeners();
      },
      onProfileChange: () {
        notifyListeners();
      }
    );
  }


  InitializationResult initialize()  {
    bool hasActiveChannel = UserService().userResult.activeChannel != null;
    bool isOnline = UserService().userResult.myChannelsResult.retrievedOnline;
    if (hasActiveChannel) {
      return InitializationResult.ready;
    } else if (isOnline && !hasActiveChannel) {
      return InitializationResult.noChannelAvailable;
    } else if (isOnline && hasActiveChannel) {
      return InitializationResult.serverConnectionError;
    }
    return InitializationResult.idle;
  }


}
