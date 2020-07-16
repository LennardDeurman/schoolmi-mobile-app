import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/roles.dart';
import 'package:schoolmi/network/routes/channel.dart';



class RolesManager extends BaseManager with UploadInterface<Role> {

  final Channel channel;

  RolesRequest _rolesRequest;

  RolesManager (this.channel) {
    _rolesRequest = RolesRequest(
        ChannelRoute(channelId: this.channel.id).roles
    );
  }

  @override
  Future<Role> saveUploadObject() {
    return executeAsync(
        performSingleUpload(
            uploadFutureBuilder: (Role role) {
              return _rolesRequest.postSingle(role);
            }
        )
    );
  }

}