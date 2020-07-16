import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/network/models/tag.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/tags.dart';
import 'package:schoolmi/network/routes/channel.dart';


class TagsManager extends BaseManager with UploadInterface<Tag> {

  final Channel channel;

  TagsRequest _tagsRequest;

  TagsManager (this.channel) {
    _tagsRequest = TagsRequest(
        ChannelRoute(channelId: this.channel.id).tags
    );
  }

  @override
  Future<List<Tag>> saveUploadObjects() {
    return executeAsync(
        performMultiUpload(
            uploadFutureBuilder: (List<Tag> tags) {
              return _tagsRequest.postAll(tags);
            }
        )
    );
  }

}
