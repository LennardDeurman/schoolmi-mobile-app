import 'package:flutter/material.dart';
import 'package:schoolmi/network/params/members.dart';
import 'package:schoolmi/widgets/dialogs/members/filter.dart';
import 'package:schoolmi/widgets/lists/channels/details/members/overview.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/pages/channels/details/members/add.dart';
import 'package:schoolmi/localization/localization.dart';

class MembersPage extends StatefulWidget {


  final MembersManager membersManager;

  MembersPage (this.membersManager);

  @override
  State<StatefulWidget> createState() {
    return MembersPageState();
  }

}

class MembersPageState extends State<MembersPage> {


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<MembersListViewState> _listViewKey = GlobalKey<MembersListViewState>();

  Widget buildFloatingActionButton() {
    if (widget.membersManager.channel.isUserAdmin) {
      return FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddMembersPage(widget.membersManager);
                }
            ));
          }
      );
    }
    return Container();
  }

  MembersFilterMode get filterMode {
    MembersRequestParams params = _listViewKey.currentState.listState.listRequestParams;
    return params.filterMode;
  }

  void changeFilterMode(MembersFilterMode filterMode) {
    setState(() {
      MembersRequestParams params = _listViewKey.currentState.listState.listRequestParams;
      params.filterMode = filterMode;
      _listViewKey.currentState.refreshIndicatorKey.currentState.show();
    });
  }

  String get title {

    Map<MembersFilterMode, String> localization = {
      MembersFilterMode.showActive:  Localization().getValue(Localization().activeMembers),
      MembersFilterMode.showBlocked:  Localization().getValue(Localization().blockedMembers),
      MembersFilterMode.showDeleted:  Localization().getValue(Localization().deletedMembers),
    };


    return localization[filterMode];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  MembersFilterDialog(onOptionSelected: (MembersFilterMode option) {
                    Navigator.of(context).pop();
                    changeFilterMode(option);
                  }, selectedOption: filterMode).show(context);
                },
              ), visible: widget.membersManager.channel.isUserAdmin)
            ]
        ),
        floatingActionButton: Visibility(
            visible: filterMode == MembersFilterMode.showActive,
            child: buildFloatingActionButton()
        ),
        body: MembersListView(this.widget.membersManager, this._scaffoldKey, key: _listViewKey)
    );
  }
}