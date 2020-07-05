import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';

enum ButtonType {
  raised,
  flat
}

class DefaultButton extends StatelessWidget {

  final Color backgroundColor;
  final bool isLoading;
  final Function onPressed;
  final Widget child;
  final EdgeInsets padding;
  final ButtonType buttonType;
  final ShapeBorder shape;
  final Key key;

  static EdgeInsets defaultPadding = EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0);

  static RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  );

  Widget get isLoadingWidget {
    return SizedBox(
      width: 23.0,
      height: 23.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  DefaultButton ({ this.backgroundColor = BrandColors.blue, this.isLoading = false, this.key, this.onPressed, this.padding, this.shape, this.buttonType = ButtonType.flat, @required this.child }) :
      super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonType == ButtonType.flat) {
      return FlatButton(
        onPressed: onPressed,
        color: backgroundColor,
        padding: padding ?? defaultPadding,
        shape: shape ?? roundedRectangleBorder,
        child: isLoading ? isLoadingWidget : child,
      );
    } else if (buttonType == ButtonType.raised) {
      return RaisedButton(
        onPressed: onPressed,
        color: backgroundColor,
        padding: padding ?? defaultPadding,
        shape: shape ?? roundedRectangleBorder,
        child: isLoading ? isLoadingWidget : child,
      );
    }
    throw new UnimplementedError("Other button types not implemented");
  }

}
