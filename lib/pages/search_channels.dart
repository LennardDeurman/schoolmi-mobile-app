import 'package:flutter/material.dart';
import 'package:schoolmi/managers/channels.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/localization/localization.dart';

class SearchChannelsPage extends StatelessWidget {

  final ChannelsManager manager;

  SearchChannelsPage (this.manager);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleLabel(
          title: Localization().getValue(Localization().search),
          color: Colors.white,
        ),
      ),
      body: SearchChannelsPage(this.manager),
    );
  }


}
