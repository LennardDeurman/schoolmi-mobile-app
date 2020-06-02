import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/cells/add_channel.dart';
import 'package:schoolmi/widgets/cells/channel.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:flutter/material.dart';

class MyChannelsListView extends ParserListView  {

  final Function(Channel) onChannelPressed;
  final Function onAddChannelPressed;

  final HomeManager homeManager;

  MyChannelsListView (this.homeManager, { this.onAddChannelPressed, this.onChannelPressed }) : super(UserService().myChannelsParser);

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
  Future performRefresh() async {
    await widget.homeManager.executeAsync(widget.homeManager.downloadChannels());
    parsingResult = UserService().loginResult.myChannelsResult; //If new channels are downloaded, and the stucture changes, we need to notify the homeManager
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: BrandColors.blue,
          height: 100,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: TitleLabel(
                    title: Localization().getValue(Localization().myChannels),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: super.build(context),
          )
        )
      ],
    );
  }

}