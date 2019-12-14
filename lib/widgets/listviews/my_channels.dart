import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/cells/add_channel.dart';
import 'package:schoolmi/widgets/cells/channel.dart';
import 'package:schoolmi/network/parsers/channels.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:flutter/material.dart';

class MyChannelsListView extends ParserListView  {

  final Function(Channel) onChannelPressed;
  final Function onAddChannelPressed;

  MyChannelsListView (ChannelsParser parser, { this.onAddChannelPressed, this.onChannelPressed }) : super(parser);

  @override
  State<StatefulWidget> createState() {
    return MyChannelsListViewState();
  }

}

class MyChannelsListViewState extends ParserListViewState<MyChannelsListView> {

  @override
  void performLoad() {
    parsingResult = UserService().loginResult.myChannelsResult; //The super call, for refreshing is not required as this is handled in the home page's homemanager
  }

  @override
  Future performRefresh() {
    return UserService().refreshData(forceRefresh: true);
  }

  @override
  bool get canLoadMore {
    return false;
  }

  @override
  Widget buildHeader(int section) {
    return Column(
      children: <Widget>[
        buildStatusBar(),
        buildAddChannelCell()
      ],
    );
  }

  Widget buildAddChannelCell() {
    return AddChannelCell(
      title: Localization().getValue(Localization().addChannelOrFind),
      subtitle: Localization().getValue(Localization().addChannelOrFindDescription),
      onPressed: widget.onAddChannelPressed,
    );
  }

  @override
  Widget buildListItem(BaseObject object) {
    Channel channel = object;
    return ChannelCell(
      channel: channel,
      isActive: UserService().loginResult.isActiveChannel(channel),
      onPressed: () {
        widget.onChannelPressed(channel);
      },
    );
  }

}