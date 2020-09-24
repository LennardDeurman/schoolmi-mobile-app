import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/managers/channels/roles.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/members.dart';
import 'package:schoolmi/network/routes/channel.dart';


class MembersManager extends BaseManager with UploadInterface<Member> {


  final Channel channel;

  RolesManager rolesManager;

  MembersRequest _membersRequest;

  MembersManager (this.channel) {
    this.rolesManager = RolesManager(this.channel);
    this._membersRequest = MembersRequest(
      ChannelRoute(
        channelId: this.channel.id
      ).members
    ); 
  }

  @override
  Future<List<Member>> saveUploadObjects() {
    return executeAsync(
        performMultiUpload(
            uploadFutureBuilder: (List<Member> members) {
              return _membersRequest.postAll(members);
            }
        )
    );
  }

  List<String> get emails {
    return uploadObjects.map((Member member) {
      return member.email;
    }).toList();
  }

  void add(String email) {
    Member member = Member.create(
        email: email,
        isAdmin: false,
        channelId: channel.id
    );
    uploadObjects.add(member);
  }

  void remove(String email) {
    uploadObjects.removeWhere((Member member) {
      return member.email == email;
    });
  }

}