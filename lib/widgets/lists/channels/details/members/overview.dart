import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/lists/base/search.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/cells/member.dart';
import 'package:schoolmi/widgets/dialogs/members/edit.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/params/members.dart';
import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/routes/channel.dart';

class MembersListView extends FetcherListView<Member> {

  final MembersManager membersManager;
  final GlobalKey<ScaffoldState> scaffoldKey;


  MembersListView (this.membersManager, this.scaffoldKey, { GlobalKey<MembersListViewState> key }) : super(key: key);

  @override
  FetcherListViewState<FetcherListView<Member>, Member> createState() {
    return MembersListViewState();
  }

}

class MembersListViewState extends SearchListViewState<MembersListView, Member> {

  bool shouldRemoveMember(Member member) {

    MembersRequestParams params = listState.listRequestParams;
    MembersFilterMode mode = params.filterMode ?? MembersFilterMode.showActive;

    switch (mode) {
      case MembersFilterMode.showActive:
        return (member.isDeleted || member.blocked);
        break;
      case MembersFilterMode.showDeleted:
        return !member.isDeleted;
        break;
      case MembersFilterMode.showBlocked:
        return !member.blocked;
        break;
    }

    return false;
  }

  @override
  ListRequestParams listRequestParams() {
    return MembersRequestParams();
  }

  @override
  Fetcher<Member> fetcher() {
    return Fetcher<Member>(
        RestRequest(
            ChannelRoute(
                channelId: widget.membersManager.channel.id
            ).members,
            objectCreator: (json) {
              return Member(json);
            }
        )
    );
  }

  @override
  Widget objectCellBuilder(Member member) {
    return MemberCell(
        member: member,
        channel: widget.membersManager.channel,
        onPressed: (Member member) {
          if (widget.membersManager.channel.isCurrentUserAdmin) {
            MembersEditingDialog(member: member, manager: widget.membersManager, scaffoldKey: widget.scaffoldKey, onModified: (Member member){
              var shouldRemove = shouldRemoveMember(member);
              if (shouldRemove) {
                listState.removeObjects([member]);
              } else {
                listState.modifyObjects([member]);
              }
            }).show(context);
          }
        }
    );
  }

  @override
  void onChangedSearchField(String value) {
    performSearch(value);
  }

}