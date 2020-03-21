import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/upload_interface.dart';
import 'package:schoolmi/managers/upload.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/network/parsers/channels.dart';

class ChannelEditManager extends ChildManager with UploadInterface<Channel> {

  final ChannelsParser parser = new ChannelsParser();

  final UploadManager avatarImageUploadManager = new UploadManager();

  ChannelEditManager (HomeManager homeManager, {Channel channel}) : super(homeManager) {
    if (channel != null) {
      uploadObject = new Channel(channel.toDictionary());
      avatarImageUploadManager.dataUrl = uploadObject.imageUrl;
    } else {
      uploadObject = new Channel({});
      uploadObject.membersCount = 1; //Every channel has at least one member when created
    }
  }

  @override
  Future<List<Channel>> saveUploadObjects() {
    Future<List<Channel>> uploadFuture = wrapUpload(parser.uploadObjects(this.uploadObjects));
    uploadFuture.then((List<Channel> channels) {
      if (channels.length > 0) {
        this.uploadObject = channels.first;
        this.homeManager.switchToChannel(channels.first);
      }
    });
    return executeAsync(uploadFuture);
  }

}