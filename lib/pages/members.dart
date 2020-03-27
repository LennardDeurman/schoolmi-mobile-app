import 'package:flutter/material.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/network/parsers/members.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/pages/add_members.dart';
import 'package:schoolmi/widgets/alerts/members_filter_options.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:scoped_model/scoped_model.dart';

class MembersPage extends StatefulWidget {

  final MembersManager membersManager;

  MembersPage (this.membersManager) {
    MembersParser parser = membersManager.parser;
    parser.queryInfo = null;
  }


  @override
  State<StatefulWidget> createState() {
    return _MembersPageState();
  }

}


class _MembersPageState extends State<MembersPage> {


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<MembersListViewState> _listViewKey = GlobalKey<MembersListViewState>();


  Widget buildFloatingActionButton() {
    if (widget.membersManager.channel != null) {
      if (widget.membersManager.channel.isUserAdmin) {
        return FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddMembersPage(AddMembersManager(widget.membersManager));
                }
              ));
            }
        );
      }
    }
    return Container();
  }

  int get filterCode {
    MembersParser parser = widget.membersManager.parser;
    if (parser.queryInfo != null) {
      return parser.queryInfo.filter;
    }
    return MembersFilterDialog.activeMembers;
  }

  String get title {

    Map<int, String> localization = {
      MembersFilterDialog.activeMembers:  Localization().getValue(Localization().activeMembers),
      MembersFilterDialog.blockedMembers:  Localization().getValue(Localization().blockedMembers),
      MembersFilterDialog.deletedMembers:  Localization().getValue(Localization().deletedMembers),
    };

    return localization[filterCode];
  }


  void _refresh(int filterCode) {
    setState(() {
      MembersParser parser = widget.membersManager.parser;
      QueryInfo queryInfo = QueryInfo();
      queryInfo.filter = filterCode;
      parser.queryInfo = queryInfo;
      _listViewKey.currentState.refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void initState() {
    widget.membersManager.homeManager.channelDetailsManager.rolesManager.download();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TitleLabel(
            title: title,
            color: Colors.white,
          ),
          actions: <Widget>[
            Visibility(child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                MembersFilterDialog(onOptionSelected: (int option) {
                  Navigator.of(context).pop();
                  _refresh(option);
                }, selectedOption: filterCode).show(context);
              },
            ), visible: widget.membersManager.channel.isUserAdmin)
          ]
        ),
        floatingActionButton: ScopedModelDescendant<MembersManager>(
          builder: (BuildContext context, Widget widget, MembersManager manager) {
            return Visibility(
              visible: filterCode == 1,
              child: buildFloatingActionButton()
            );
          }
        ),
        body: ScopedModelDescendant<MembersManager>(
          builder: (BuildContext context, Widget widget, MembersManager manager) {
            if (manager.parser != null) {
              return MembersListView(this.widget.membersManager, this._scaffoldKey, key: _listViewKey);
            }
            return Container();
          }
        )
    ), model: this.widget.membersManager);
  }


}


