import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/managers/tags.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/models/data/channel.dart';


class ChannelDetailsChildManager extends ChildManager {

  Channel channel;

  ChannelDetailsChildManager (HomeManager homeManager) : super(homeManager);

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

