import 'package:schoolmi/widgets/alerts/members_filter_options.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey;

  MembersListView (this.manager, this.scaffoldKey, { GlobalKey<MembersListViewState> key }) : super(manager.parser, key: key);

  @override
  State<StatefulWidget> createState() {
    return MembersListViewState();
  }

}

class MembersListViewState extends ParserListViewState<MembersListView> {

  @override
  void initState() {
    super.initState();

    widget.manager.onNewMembersAdded = () {
      refreshIndicatorKey.currentState.show();
    };

  }


  bool shouldRemoveMember(Member member) {
    MembersParser membersParser = widget.parser;
    int filterOption = MembersFilterDialog.activeMembers;
    if (membersParser.queryInfo != null) {
      filterOption = membersParser.queryInfo.filter;
    }

    return (filterOption == MembersFilterDialog.activeMembers && (member.isDeleted || member.blocked))
        ||
        (filterOption == MembersFilterDialog.deletedMembers && !member.isDeleted)
        ||
        (filterOption == MembersFilterDialog.blockedMembers && !member.blocked);
  }

  @override
  Widget buildListItem(BaseObject object) {
    Member member = object;
    MembersParser membersParser = widget.parser;
    return MemberCell(
      member: member,
      channel: membersParser.channel,
      onPressed: (Member member) {
        if (membersParser.channel.isUserAdmin && !member.isCurrentUser) {





          MembersEditingDialog(member: member, manager: widget.manager, scaffoldKey: widget.scaffoldKey, onModified: (Member member){
            if (shouldRemoveMember(member)) {
              setState(() {
                parsingResult.objects.removeWhere((object) {
                  return member.email == (object as Member).email;
                });
              });
            }

          }).show(context);
        }
      }
    );
  }

}