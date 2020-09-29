import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/managers/channels/tags.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/channel_details.dart';

enum InitializationResult {
  idle,
  ready,
  serverConnectionError,
  noChannelAvailable,
}

class HomeManager extends BaseManager {

  UserEventsHandler userEventsHandler;

  TagsManager tagsManager;
  MembersManager membersManager;

  HomeManager () {
    userEventsHandler = UserEventsHandler(
      onActiveChannelChange: () {
        initializeChannelManagers();
        notifyListeners();
      },
      onProfileChange: () {
        notifyListeners();
      }
    );
  }

  void initializeChannelManagers() {
    if (UserService().userResult.activeChannel != null) {
      membersManager = MembersManager(UserService().userResult.activeChannel);
      tagsManager = TagsManager(UserService().userResult.activeChannel);
    }
  }

  void onChannelChange(Channel editedChannel) {
    UserService().userResult.activeChannel.parse(editedChannel.dictionary);
    notifyListeners();
  }

  InitializationResult initialize()  {
    initializeChannelManagers();
    bool hasActiveChannel = UserService().userResult.activeChannel != null;
    bool isOnline = UserService().userResult.myChannelsResult.retrievedOnline;
    if (hasActiveChannel) {
      return InitializationResult.ready;
    } else if (isOnline && !hasActiveChannel) {
      return InitializationResult.noChannelAvailable;
    } else if (!isOnline && !hasActiveChannel) {
      return InitializationResult.serverConnectionError;
    }
    return InitializationResult.idle;
  }

  Future leaveChannel() async {
    var channels = UserService().userResult.myChannelsResult.objects.where((channel) {
      return !UserService().userResult.isActiveChannel(channel);
    }).toList();
    Channel newActiveChannel;
    if (channels.length > 0) {
      newActiveChannel = channels.first;
    }
    UserService().userResult.myChannelsResult.objects = channels;
    Future leaveChannelFuture = ChannelDetailsRequest(UserService().userResult.activeChannel.id).leave();
    Future switchChannelFuture = switchToChannel(newActiveChannel);
    return Future.wait([leaveChannelFuture, switchChannelFuture]);
  }

  Future joinChannel(Channel channel) {
    return ChannelDetailsRequest(channel.id).join().then((member) {
      switchToChannel(channel);
    });
  }

  Future switchToChannel(Channel channel) {
    UserService().userResult.activeChannel = channel;
    var newProfile = UserService().userResult.myProfile;
    newProfile.activeChannelId = channel.id;
    return UserService().userResult.saveMyProfile(newProfile);
  }

  Future refreshData() {
    return executeAsync(UserService().userResult.refreshAll());
  }
}
