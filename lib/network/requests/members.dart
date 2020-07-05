import 'package:schoolmi/network/requests/abstract/channel_subobjects.dart';
import 'package:schoolmi/network/models/member.dart';


class MembersRequest extends ChannelSubObjectsRequest<Member> {

  MembersRequest (String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return Member(map);
      }
  );

}