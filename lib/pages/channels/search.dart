import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/lists/channels/search.dart';
import 'package:schoolmi/network/models/channel.dart';

class SearchChannelsPage extends StatelessWidget {

  final Future Function(Channel) joinChannelFutureBuilder;

  SearchChannelsPage ({ this.joinChannelFutureBuilder });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleLabel(
          title: Localization().getValue(Localization().search),
          color: Colors.white,
        ),
      ),
      body: SearchChannelsListView(
        joinChannelFutureBuilder: joinChannelFutureBuilder
      ),
    );
  }


}
