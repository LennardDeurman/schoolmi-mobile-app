

import 'package:flutter/material.dart';
import 'package:schoolmi/managers/channels.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/pages/search_channels.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/add_channels.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/presenter.dart';

class AddChannelsPage extends StatefulWidget {

  final HomeManager homeManager;

  AddChannelsPage (this.homeManager);

  @override
  State<StatefulWidget> createState() {
    return _AddChannelsPageState();
  }

}

class _AddChannelsPageState extends State<AddChannelsPage> {

  ChannelsManager _channelsManager;
  Presenter _presenter;


  @override
  void initState() {
    super.initState();
    _channelsManager = new ChannelsManager(this.widget.homeManager);
    _presenter = new Presenter(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TitleLabel(
            title: Localization().getValue(Localization().newChannel),
            color: Colors.white,
          )
        ),
        body: AddChannelsListView(
          _channelsManager,
          onAddChannelPressed: () {
            _presenter.showChannelEdit(_channelsManager.homeManager);
          },
          onSearchPressed: _onSearchPressed,
        ),

    );
  }


  void _onSearchPressed() {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return SearchChannelsPage(_channelsManager);
      }
    ));
  }

}
