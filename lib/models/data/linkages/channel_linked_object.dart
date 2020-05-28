import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/constants/keys.dart';

class ChannelLinkedObject {

  int channelId;
  Channel channel;
  Member member;

  void parseChannelLink(Map<String, dynamic> dictionary) {
    channelId = dictionary[Keys().channelId];
    Map memberDictionary = dictionary[Keys().member];
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