import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/roles.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/listviews/search_listview.dart';
import 'package:schoolmi/widgets/message_container.dart';

class RolesListView extends ParserListView  {

  final RolesManager rolesManager;
  final Function(Role) onRolePressed;
  final Role selectedRole;

  RolesListView (this.rolesManager, { this.onRolePressed, this.selectedRole } ) : super(rolesManager.parser);

  @override
  State<StatefulWidget> createState() {
    return RolesListViewState();
  }

}

class RoleCell extends StatelessWidget {

  final Role role;
  final Function(Role) onRolePressed;
  final bool isSelected;

  RoleCell (this.role, { this.onRolePressed, this.isSelected = false });

  @override
  Widget build(BuildContext context) {
    return Container(child: Material(child: InkWell(child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10
        ),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RegularLabel(
                  title: role.name,
                  fontWeight: FontWeight.bold,
                ),
                Visibility(
                    visible: role.id == null,
                    child: RegularLabel(
                      title: Localization().getValue(Localization().newRoleHint),
                      customSize: 12,
                    )
                )
              ],
            ),
            Spacer(),
            Visibility(
              child: Icon(Icons.check_circle, color: BrandColors.green),
              visible: isSelected,
            ),
            Visibility(
              child: Icon(Icons.chevron_right, color: BrandColors.grey),
              visible: !isSelected,
            ),

          ],
        )
    ), onTap: () {
      if (this.onRolePressed != null) {
        this.onRolePressed(role);
      }
    }), color: Colors.transparent), decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BrandColors.blueGrey
            )
        )
    ));
  }


}

class RolesListViewState extends SearchListViewState<RolesListView> {

  @override
  void initState() {
    super.initState();
    widget.rolesManager.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.rolesManager.removeListener(_updateState);
  }

  @override
  void performLoad() {
    if (widget.rolesManager.data != null) {
        parsingResult = widget.rolesManager.data;
    } else {
      super.performLoad();
    }
  }

  @override
  Widget buildNoResultsBackground() {
    if (!hasSearch) {
      return MessageContainer(
          topWidget: SvgPicture.asset(AssetPaths.search, width: 80),
          title: Localization().getValue(Localization().noResults),
          subtitle: Localization().getValue(Localization().noRolesHint)
      );
    }

    return Container();

  }
  @override
  String get searchHint {
    return Localization().getValue(Localization().rolesHint);
  }

  @override
  Future performRefresh() async {
    parsingResult = await widget.rolesManager.download(); //If new channels are downloaded, and the stucture changes, we need to notify the homeManager
  }

  @override
  bool get canLoadMore {
    return false;
  }



  @override
  Widget buildHeader(int section) {
    List<Widget> children = [];
    String search = this.search;
    if (search != null) {
      Role role = Role.create(name: search);
      if (!parsingResult.objects.contains(role)) {
        children.add(buildListItem(role));
      }
    }


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }



  bool isSelected(Role role) {
    return widget.selectedRole == role;
  }

  void _deleteRole(Role role) {
    widget.rolesManager.deleteRole(role).catchError((e) {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  @override
  Widget buildListItem(BaseObject object) {
    Role role = object;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: RoleCell(role, onRolePressed: widget.onRolePressed, isSelected: isSelected(role)),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: Localization().getValue(Localization().delete),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deleteRole(role);
          },
        )
      ],
    );
  }

  @override
  void onChangedSearchField(String value) {
    super.onChangedSearchField(value);
    performSearch(value);
    setState(() {});
  }



}