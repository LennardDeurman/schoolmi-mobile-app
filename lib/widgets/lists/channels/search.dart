import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/routes/global.dart';
import 'package:schoolmi/widgets/cells/channel.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/lists/base/search.dart';

class SearchChannelsListView extends FetcherListView<Channel> {

  final Future Function(Channel) joinChannelFutureBuilder;

  SearchChannelsListView ({ this.joinChannelFutureBuilder });

  @override
  FetcherListViewState<FetcherListView<Channel>, Channel> createState() {
    return SearchChannelsListViewState();
  }

}

class SearchChannelsListViewState extends SearchListViewState<SearchChannelsListView, Channel> {

  @override
  String get searchHint {
    return Localization().getValue(Localization().findYourChannels);
  }

  @override
  Fetcher<Channel> fetcher() {
    return Fetcher<Channel>(
      RestRequest<Channel>(
        GlobalRoute().publicChannels,
        objectCreator: (Map<String, dynamic> map) {
          return Channel(map);
        }
      )
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
  void onChangedSearchField(String value) {
    performSearch(value);
  }

}