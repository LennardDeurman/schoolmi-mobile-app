import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/cells/member.dart';
import 'package:schoolmi/widgets/alerts/edit_members.dart';
import 'package:schoolmi/network/parsers/members.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:flutter/material.dart';

class MembersListView extends ParserListView {

  final MembersManager manager;

  MembersListView (this.manager) : super(manager.parser);

  @override
  State<StatefulWidget> createState() {
    return _MembersListViewState();
  }

}

class _MembersListViewState extends ParserListViewState<MembersListView> {

  @override
  Widget buildListItem(BaseObject object) {
    Member member = object;
    MembersParser membersParser = widget.parser;
    return MemberCell(
      member: member,
      channel: membersParser.channel,
      onPressed: (Member member) {
        if (membersParser.channel.isUserAdmin && !member.isCurrentUser) {
          MembersEditingDialog(member: member, manager: widget.manager).show(context);
        }
      }
    );
  }

}