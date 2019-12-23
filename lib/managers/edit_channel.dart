import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/upload_interface.dart';
import 'package:schoolmi/managers/upload.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/network/parsers/channels.dart';

class ChannelEditManager extends ChildManager with UploadInterface<Channel> {

  final Channel channel;

  final ChannelsParser parser = new ChannelsParser();

  final UploadManager avatarImageUploadManager = new UploadManager();

  ChannelEditManager (HomeManager homeManager, {this.channel}) : super(homeManager) {
    if (channel != null) {
      uploadObject = new Channel(channel.toDictionary());
      avatarImageUploadManager.dataUrl = uploadObject.imageUrl;
    } else {
      uploadObject = new Channel({});
    }
  }

  @override
  Future<List<Channel>> saveUploadObjects() {
    Future<List<Channel>> uploadFuture = parser.uploadObjects(this.uploadObjects);
    uploadFuture.then((List<Channel> channels) {
      if (channels.first != null) {
        this.uploadObject = channels.first;
        this.homeManager.switchToChannel(channels.first);
      }
    });
    return uploadFuture;
  }

}