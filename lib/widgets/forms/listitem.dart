import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/constants/brand_colors.dart';

class ListItem extends StatelessWidget {

  final Widget leading;
  final Widget trailing;
  final Widget title;
  final Widget subtitle;
  final EdgeInsets contentPadding;
  final Function onPressed;
  final Border border;

  Border get defaultBorder {
    return Border(
        bottom: BorderSide(
            width: 1,
            color: BrandColors.blueGrey
        )
    );
  }


  ListItem ({this.leading, this.title, this.subtitle, this.trailing, this.contentPadding, this.onPressed, this.border });

  static ListItem withTextField({ String title, String hintText, Function validator, Function onSaved, TextEditingController controller }) {
    return ListItem(
      title: Container(
        child: TitleLabel(
          title: title,
          size: TitleSize.small,
        ),
        margin: EdgeInsets.only(
            bottom: 15
        ),
      ),
      subtitle: DefaultTextField(
        textFieldType: TextFieldType.filled,
        hint: hintText,
        onSaved: onSaved,
        validator: validator,
        controller: controller,
      ),
      contentPadding: EdgeInsets.all(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Material(child: InkWell(child: Container(child: ListTile(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      leading: leading,
      contentPadding: contentPadding,
    )), onTap: onPressed), color: Colors.transparent), decoration: BoxDecoration(
        color: Colors.white,
        border: border ?? defaultBorder
    ));
  }


}