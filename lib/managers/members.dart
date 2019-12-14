import 'package:schoolmi/managers/channel_details.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/network/parsers/members.dart';

class MembersManager extends ChannelDetailsChildManager {


  MembersManager (HomeManager homeManager) : super(homeManager);


  @override
  void onChannelLoad(Channel channel) {
    parser = new MembersParser(channel);
    notifyListeners();
  }






}