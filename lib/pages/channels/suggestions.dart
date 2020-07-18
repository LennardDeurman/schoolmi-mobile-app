import 'package:flutter/material.dart';
import 'package:schoolmi/extensions/presenter.dart';
import 'package:schoolmi/pages/channels/search.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/lists/channels/suggestions.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/localization/localization.dart';

class SuggestedChannelsPage extends StatelessWidget {

  final Function onChannelEdit;
  final Future Function(Channel) joinChannelFutureBuilder;

  SuggestedChannelsPage ({ this.onChannelEdit, this.joinChannelFutureBuilder });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TitleLabel(
            title: Localization().getValue(Localization().newChannel),
            color: Colors.white,
          )
      ),
      body: SuggestedChannelsListView(
        onAddChannelPressed: () {
          Presenter(context).showChannelEdit(onChannelEdit: this.onChannelEdit);
        },
        onSearchPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return SearchChannelsPage(
                  joinChannelFutureBuilder: joinChannelFutureBuilder,
                );
              }
          ));
        },
        joinChannelFutureBuilder: joinChannelFutureBuilder,
      ),

    );
  }





}