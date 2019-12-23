import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/network/parsers/channels.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/cells/public_channel.dart';
import 'package:schoolmi/widgets/textfield.dart';
import 'package:schoolmi/widgets/announcer.dart';
import 'package:schoolmi/managers/channels.dart';
import 'package:schoolmi/models/base_object.dart';
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

class _SearchChannelsListViewState extends ParserListViewState<SearchChannelsListView> {


  final FocusNode _searchTextFieldFocusNode = FocusNode();

  @override
  Widget buildListItem(BaseObject object) {
    Channel channel = object;
    return PublicChannelCell(
      channel: channel,
      onPressedJoin: (Channel channel) {
        int indexOf = parsingResult.objects.indexOf(channel);
        parsingResult.objects.removeAt(indexOf);
        widget.manager.join(channel).catchError((e) {
          parsingResult.objects.insert(indexOf, channel);
          showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: BrandColors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              color: Colors.white,
              child: DefaultTextField(
                onChanged: (String value) async {
                  ChannelsParser parser = widget.parser;
                  parser.queryInfo = new QueryInfo(
                      search: value
                  );
                  await performRefresh();
                },
                focusNode: _searchTextFieldFocusNode,
                hint: Localization().getValue(Localization().findYourChannels),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                color: BrandColors.blueGrey,
                child: Announcer(title: Localization().getValue(Localization().results))
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: buildRefreshWidget()
              ),
            )
          ],
        ),
      ),
    );
  }



}