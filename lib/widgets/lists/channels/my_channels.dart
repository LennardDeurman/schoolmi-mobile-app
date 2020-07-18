import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/cells/channel.dart';

class MyChannelsListView extends FetcherListView<Channel> {

  final Function onChannelPressed;
  final Function onAddChannelPressed;

  MyChannelsListView ({ this.onChannelPressed, this.onAddChannelPressed });

  @override
  FetcherListViewState<FetcherListView<Channel>, Channel> createState() {
    return MyChannelsListViewState();
  }

}

class MyChannelsListActions extends ListActionsDelegate {

  MyChannelsListActions (ListState state, BuildContext context) : super(state, context);

  @override
  Future performInitialLoad() {
    return Future.value(() {
      return listState.complete(UserService().userResult.myChannelsResult);
    });
  }

  @override
  Future performRefresh() async {
    loadFuture(
        UserService().userResult.refreshMyChannels().then((res) {
          listState.complete(res);
        }).catchError((e) {
          onRefreshError(e);
        })
    );
  }

  @override
  Future loadMore() {
    throw UnimplementedError();
  }

}

class MyChannelsTableViewProvider extends FetcherTableViewProvider<Channel> {

  final Function onAddChannelPressed;

  MyChannelsTableViewProvider( ListState<Channel> listState, { Function builder, this.onAddChannelPressed }) : super(listState, builder: builder);

  Widget buildAddChannelCell() {
    return AddChannelCell(
      title: Localization().getValue(Localization().addChannelOrFind),
      subtitle: Localization().getValue(Localization().addChannelOrFindDescription),
      onPressed: onAddChannelPressed,
    );
  }

  @override
  Widget sectionHeaderBuilder(int section) {
    return Column(
      children: <Widget>[
        buildStatusBar(),
        buildAddChannelCell()
      ],
    );
  }

}

class MyChannelsListViewState extends FetcherListViewState<MyChannelsListView, Channel> {

  @override
  void initState() {
    super.initState();
    listState.alwaysDisableLoadMore = true;
  }

  @override
  FetcherTableViewProvider<Channel> tableViewProvider() {
    return MyChannelsTableViewProvider(listState, builder: objectCellBuilder, onAddChannelPressed: widget.onAddChannelPressed);
  }

  @override
  ListActionsDelegate listActionsDelegate() {
    return MyChannelsListActions(this.listState, context);
  }

  @override
  Widget objectCellBuilder(Channel channel) {
    return ChannelCell(
      channel: channel,
      isActive: UserService().userResult.isActiveChannel(channel),
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