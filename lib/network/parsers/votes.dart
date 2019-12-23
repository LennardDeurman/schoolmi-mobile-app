
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/base_object.dart';

class VotesParser extends ChannelBaseNetworkParser {

  VotesParser (Channel channel) : super(channel);

  @override
  String get uploadUrl {
    return Urls.votes(channelId: channel.id);
  }

  @override
  String get downloadUrl {
    throw new UnimplementedError("This endpoint cannot be used for downloading");
  }

  @override
  BaseObject toObject(Map dictionary) {
    return null;
  }

}
