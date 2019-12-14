import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/models/data/channel.dart';

abstract class ChannelBaseNetworkParser extends NetworkParser {

  Channel channel;

  ChannelBaseNetworkParser (this.channel) : super();


}