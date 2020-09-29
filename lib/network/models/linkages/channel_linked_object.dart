import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';

class ChannelLinkedObject {

  int channelId;
  Channel channel;
  Member member;

  void parseChannelLink(Map<String, dynamic> dictionary) {
    channelId = dictionary[Keys().channelId];
    Map memberDictionary = ParsableObject.dictOrFirst(dictionary[Keys().member]);
    if (memberDictionary != null) {
      member = Member(memberDictionary);
    }
    Map channelDictionary = dictionary[Keys().channel];
    if (channelDictionary != null) {
      channel = Channel(channelDictionary);
    }
  }


  Map<String, dynamic> channelLinkDictionary() {
    return {
      Keys().channelId: channelId,
      Keys().member: ParsableObject.tryGetDict(member),
      Keys().channel: ParsableObject.tryGetDict(channel)
    };
  }

}