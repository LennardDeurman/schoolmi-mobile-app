import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/routes/global.dart';
import 'package:schoolmi/widgets/cells/channel.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';

class SuggestedChannelsListView extends FetcherListView<Channel> {

  final Function onAddChannelPressed;
  final Function onSearchPressed;
  final Future Function(Channel) joinChannelFutureBuilder;

  SuggestedChannelsListView ({ this.onAddChannelPressed, this.onSearchPressed, this.joinChannelFutureBuilder });

  @override
  FetcherListViewState<FetcherListView<Channel>, Channel> createState() {
    return SuggestedChannelsListViewState();
  }

}

class SuggestedChannelsTableViewProvider extends FetcherTableViewProvider<Channel> {

  final Function onAddChannelPressed;
  final Function onSearchPressed;

  SuggestedChannelsTableViewProvider (ListState<Channel> listState, { Function builder, this.onAddChannelPressed, this.onSearchPressed }) : super(listState, builder: builder);

  @override
  int get sectionCount {
    return 2;
  }

  @override
  int numberOfRows(int section) {
    if (section == 1) {
      return listState.fetchResult.objects.length;
    }
    return 1;
  }

  @override
  Widget rowBuilder(BuildContext context, int index, int section) {
    if (section == 0) {
      return AddChannelCell(
        title: Localization().getValue(Localization().createNewChannel),
        subtitle: Localization().getValue(Localization().createNewChannelDetail),
        onPressed: this.onAddChannelPressed,
      );
    } else if (section == 1) {
      return objectCellBuilder(listState.fetchResult.objects[index]);
    }
    return super.rowBuilder(context, index, section);
  }

  @override
  Widget sectionHeaderBuilder(int section) {
    if (section == 0) {
      return Container(
        padding: EdgeInsets.all(15),
        child: RegularLabel(
          title: Localization().getValue(Localization().createChannelTitle),
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (section == 1) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularLabel(
                    title: Localization().getValue(Localization().publicChannels),
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  RegularLabel(
                    title: Localization().getValue(Localization().publicChannelsDetail),
                  )
                ],
              ),
            ),
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            fillColor: BrandColors.blue,
            padding: EdgeInsets.all(4),
            child: Icon(Icons.search, color: Colors.white),
            onPressed: this.onSearchPressed,
          )
        ],
      );
    }
    return super.sectionHeaderBuilder(section);
  }

}

class SuggestedChannelsListViewState extends FetcherListViewState<SuggestedChannelsListView, Channel> {

  Fetcher<Channel> _fetcher;

  @override
  void initState() {
    listState.alwaysDisableLoadMore = true;
    _fetcher = Fetcher(
      RestRequest<Channel>(
        GlobalRoute().publicChannels,
        objectCreator: (Map<String, dynamic> map) {
          return Channel(map);
        }
      )
    );
    super.initState();
  }

  @override
  FetcherTableViewProvider tableViewProvider() {
    return SuggestedChannelsTableViewProvider(listState, builder: (object) {
      return objectCellBuilder(object);
    }, onSearchPressed: widget.onSearchPressed, onAddChannelPressed: widget.onAddChannelPressed);
  }

  @override
  ListActionsDelegate listActionsDelegate() {
    return DefaultFetcherListActionsDelegate(
      listState,
      context,
      _fetcher
    );
  }

  @override
  Widget objectCellBuilder(Channel object) {
    return PublicChannelCell(
      channel: object,
      onPressedJoin: (Channel channel) {

        int indexOf = listState.resolveIndexAndRemove(channel);
        widget.joinChannelFutureBuilder(channel).then((v) {
          showSnackBar(message: Localization().getValue(Localization().youAreMember), isError: false, buildContext: context);
        }).catchError((e) {
          listState.restoreObjectAtIndex(indexOf, channel);
          showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
        });

      },
    );
  }

  @override
  Widget buildBackground() {
    return Container();
  }

}