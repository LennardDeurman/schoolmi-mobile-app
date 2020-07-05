import 'package:schoolmi/network/requests/abstract/channel_subobjects.dart';
import 'package:schoolmi/network/models/role.dart';

class RolesRequest extends ChannelSubObjectsRequest<Role> {

  RolesRequest (String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return Role(map);
      }
  );

}