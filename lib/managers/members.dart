import 'dart:async';

import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/managers/channel_details.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/roles.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/network/parsers/members.dart';
import 'package:schoolmi/managers/upload_interface.dart';


class AddMembersManager extends BaseManager with UploadInterface<Member> {

  MembersManager membersManager;

  AddMembersManager (this.membersManager);

  List<String> get emails {
    return membersManager.uploadObjects.map((Member member) {
      return member.email;
    }).toList();
  }

  @override
  Future<List<Member>> saveUploadObjects() {
    return executeAsync<List<Member>>(wrapUpload(membersManager.performUpload(membersManager.parser))).whenComplete(() {
      membersManager.onNewMembersAdded();
    });
  }

  void add(String email) {
    Member member = Member.create(
      email: email,
      isAdmin: false,
      channelId: membersManager.channel.id
    );
    membersManager.uploadObjects.add(member);
  }

  void remove(String email) {
    membersManager.uploadObjects.removeWhere((Member member) {
      return member.email == email;
    });
  }

}


class MembersManager extends ChannelDetailsChildManager with UploadInterface<Member> {

  Function onNewMembersAdded;

  MembersManager (HomeManager homeManager) : super(homeManager);

  @override
  void onChannelLoad(Channel channel) {
    parser = new MembersParser(channel);
    uploadObjects = [];
  }


  @override
  Future<List<Member>> saveUploadObjects() {
    return executeAsync<List<Member>>(wrapUpload(performUpload(parser)));
  }


}