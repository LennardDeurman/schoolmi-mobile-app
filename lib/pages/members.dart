import 'package:flutter/material.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/localization/localization.dart';

class MembersPage extends StatefulWidget {

  final MembersManager membersManager;

  MembersPage (this.membersManager);


  @override
  State<StatefulWidget> createState() {
    return _MembersPageState();
  }

}


class _MembersPageState extends State<MembersPage> {


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  Widget buildFloatingActionButton() {
    if (widget.membersManager.channel != null) {
      if (widget.membersManager.channel.isUserAdmin) {
        return FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {

            }
        );
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: widget.membersManager,
        child: ScopedModelDescendant<MembersManager>(builder: (BuildContext context, Widget widget, MembersManager manager) {
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: TitleLabel(
                  title: Localization().getValue(Localization().members, usePluralForm: true),
                  color: Colors.white,
                ),
              ),
              floatingActionButton: buildFloatingActionButton(),
              body: _membersLayout.buildBody()
          );
        })
    );
  }


}


