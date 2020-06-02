import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/cells/public_channel.dart';
import 'package:schoolmi/widgets/listviews/search_listview.dart';
import 'package:schoolmi/managers/channels.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:flutter/material.dart';

class SearchChannelsListView extends ParserListView {

  final ChannelsManager manager;

  SearchChannelsListView (this.manager) : super(manager.searchParser);

  @override
  State<StatefulWidget> createState() {
    return _SearchChannelsListViewState();
  }

}

class _SearchChannelsListViewState extends SearchListViewState<SearchChannelsListView> {

  @override
  String get searchHint {
    return Localization().getValue(Localization().findYourChannels);
  }

  @override
  Widget buildListItem(BaseObject object) {
    Channel channel = object;
    return PublicChannelCell(
      channel: channel,
      onPressedJoin: (Channel channel) {

        int indexOf = parsingResult.objects.indexOf(channel);
        setState(() {
          parsingResult.objects.removeAt(indexOf);
        });

        widget.manager.join(channel).then((_) {
          widget.manager.homeManager.switchToChannel(channel);
          showSnackBar(message: Localization().getValue(Localization().youAreMember), isError: true, buildContext: context);
        }).catchError((e) {
          setState(() {
            parsingResult.objects.insert(indexOf, channel);
          });
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