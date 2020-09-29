import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/managers/file_upload.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/channels.dart';


class ChannelEditManager extends BaseManager with UploadInterface<Channel> {

  FileUploadManager avatarImageUploadManager;

  final MyChannelsRequest request = MyChannelsRequest();

  ChannelEditManager ({Channel channel}) {
    if (channel != null) {
      uploadObject = new Channel(channel.toDictionary());
    } else {
      uploadObject = new Channel({});
      request.formatter.postConfig.skipKeys.add(Keys().colorIndex);
      uploadObject.membersCount = 1; //Every channel has at least one member when created
    }
    avatarImageUploadManager = new FileUploadManager(uploadObject.imageUrl);
  }
  
  @override
  Future<Channel> saveUploadObject() {
    return executeAsync(request.postSingle(
        uploadObject
    ).then((value) => uploadObject = value));
  }

}