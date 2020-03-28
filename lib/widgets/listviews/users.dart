
import 'package:flutter/material.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/widgets/cells/user.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';

class UsersListView extends ParserListView {

  final Function(Profile) customCellBuilder;

  UsersListView (NetworkParser parser, { this.customCellBuilder }) : super(parser);

  @override
  State<StatefulWidget> createState() {
    return _UsersListViewState();
  }
}

class _UsersListViewState extends ParserListViewState<UsersListView> {

  @override
  Widget buildListItem(BaseObject object) {
    if (this.widget.customCellBuilder != null) {
      return this.widget.customCellBuilder(object);
    }
    return UserCell(object);
  }

}