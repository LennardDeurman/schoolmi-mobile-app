import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/backgrounds.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/lists/base/search.dart';
import 'package:schoolmi/widgets/cells/role.dart';
import 'package:schoolmi/managers/channels/roles.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/routes/channel.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';

class RolesListView extends FetcherListView<Role> {

  final RolesManager rolesManager;
  final Function(Role) onRolePressed;
  final Role selectedRole;

  RolesListView ( this.rolesManager, { this.onRolePressed, this.selectedRole } );

  @override
  FetcherListViewState<FetcherListView<Role>, Role> createState() {
    return RolesListViewState();
  }

}

class RolesTableViewProvider extends FetcherTableViewProvider<Role> {

  RolesTableViewProvider (ListState<Role> listState, { Function builder }) : super(listState, builder: builder);

  @override
  Widget sectionHeaderBuilder(int section) {
    List<Widget> children = [];
    if (listState.listRequestParams.hasSearch) {
      Role role = Role.create(name: listState.listRequestParams.search);
      if (!listState.fetchResult.objects.contains(role)) {
        children.add(builder(role));
      }
    }


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }

}

class RolesListViewState extends SearchListViewState<RolesListView, Role> {


  @override
  String get searchHint {
    return Localization().getValue(Localization().rolesHint);
  }

  @override
  Widget buildBackground() {
    if (listState.fetchResult != null && listState.fetchResult.objects.length == 0 && listState.listRequestParams.hasSearch) {
      return MessageContainer(
          topWidget: SvgPicture.asset(AssetPaths.search, width: 80),
          title: Localization().getValue(Localization().noResults),
          subtitle: Localization().getValue(Localization().noRolesHint)
      );//Show an empty container instead of default, when no results are returned
    } else {
      return super.buildBackground();
    }
  }

  @override
  void onChangedSearchField(String value) {
    performSearch(value);
  }

  @override
  Fetcher<Role> fetcher() {
    return Fetcher<Role>(
        RestRequest(
            ChannelRoute(
                channelId: widget.rolesManager.channel.id
            ).roles,
            objectCreator: (json) {
              return Role(json);
            }
        )
    );
  }

  FetcherTableViewProvider tableViewProvider() {
    return RolesTableViewProvider(listState, builder: (object) {
      return objectCellBuilder(object);
    });
  }


  void _deleteRole(Role role) {
    listState.removeObjects([role]);
    role.isDeleted = true;
    widget.rolesManager.uploadObject = role;
    widget.rolesManager.saveUploadObject().catchError((e) {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  @override
  Widget objectCellBuilder(Role role) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: RoleCell(role, onRolePressed: widget.onRolePressed, isSelected: widget.selectedRole == role),
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


}