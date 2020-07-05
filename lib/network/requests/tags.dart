import 'package:schoolmi/network/requests/abstract/channel_subobjects.dart';
import 'package:schoolmi/network/models/tag.dart';

class TagsRequest extends ChannelSubObjectsRequest<Tag> {

  TagsRequest(String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return Tag(map);
      }
  );

}
