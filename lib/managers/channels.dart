import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/network/parsers/channels.dart';

class ChannelsManager extends ChildManager {

  final ChannelsParser publicChannelsParser = new ChannelsParser(showOpenChannels: true);
  final ChannelsParser searchParser = new ChannelsParser(showOpenChannels: true);

  ChannelsManager (HomeManager homeManager) : super(homeManager);

  Future join(Channel channel) {

    return Api.joinChannel(channelId: channel.id);
  }

}