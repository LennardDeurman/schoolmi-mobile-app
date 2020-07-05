import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/exceptions.dart';

ScaffoldFeatureController showSnackBar({
  GlobalKey<ScaffoldState> scaffoldKey,
  BuildContext buildContext,
  @required String message,
  @required bool isError,
}) {

  if (scaffoldKey != null) {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: isError ? BrandColors.red : BrandColors.green),
    );
  }

  if (buildContext != null) {
    Scaffold.of(buildContext).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: isError ? BrandColors.red : BrandColors.green)
    );
  }

  throw InvalidOperationException("Either a buildContext or scaffoldkey is required");

}
