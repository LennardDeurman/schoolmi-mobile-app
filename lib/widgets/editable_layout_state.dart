import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/svg_icon.dart';
import 'package:schoolmi/constants/asset_paths.dart';

abstract class EditableLayoutState<T extends StatefulWidget> extends State<T> {

  bool _isEditing = false;

  bool get isEditing {
    return _isEditing;
  }

  set isEditing (bool value) {
    setState(() {
      _isEditing = value;
    });
  }

  String get title {
    return "";
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        Visibility(
          visible: isEditing,
          child: FlatButton(
            child: Text(Localization().getValue(Localization().cancel), style: TextStyle(
                color: Colors.white
            )),
            onPressed: () {
              isEditing = false;
            },
          ),
        )
      ],
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(onPressed: onFabPressed, child: buildFloatingActionButtonChild(context), backgroundColor: BrandColors.blue);
  }


  Widget buildFloatingActionButtonChild(BuildContext context) {
    return SvgIcon(
      assetUrl: isEditing ? AssetPaths.done : AssetPaths.edit,
      color: Colors.white,
      size: 25.0,
    );
  }

  Widget buildReadOnlyBody (BuildContext context);

  Widget buildEditableBody(BuildContext context);

  Widget buildBody(BuildContext context) {
    if (isEditing) {
      return buildEditableBody(context);
    } else {
      return buildReadOnlyBody(context);
    }
  }

  Widget buildFabLoadingIndicator() {
    return SizedBox(
      width: 23.0,
      height: 23.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  void onClickFinishEditing();

  void onClickStartEditing();

  void onFabPressed() {
    if (isEditing) {
      onClickFinishEditing();
    } else {
      onClickStartEditing();
    }
    isEditing = !isEditing;
  }


}