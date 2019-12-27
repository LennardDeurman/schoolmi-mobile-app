import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';

enum TextFieldType {
  filled,
  regular,
  search
}

class DefaultTextField extends StatelessWidget {

    final String hint;
    final String title;
    final bool obscureText;
    final bool showClearOption;
    final Function validator;
    final Function onSaved;
    final Function onSubmitted;
    final Function onChanged;
    final Function onEditingComplete;
    final TextCapitalization textCapitalization;
    final TextInputType textInputType;
    final TextEditingController controller;
    final FocusNode focusNode;
    final int maxLines;
    final TextFieldType textFieldType;
    final Key key;


    DefaultTextField ({ this.title, this.textFieldType = TextFieldType.regular, this.hint, this.obscureText = false, this.showClearOption = false, this.validator,
      this.onSaved, this.onSubmitted, this.onChanged, this.onEditingComplete, this.textCapitalization, this.textInputType, this.controller,
      this.focusNode, this.maxLines, this.key
    }) : super(key: key);

    InputBorder get errorBorder {
      return OutlineInputBorder(
        borderSide: BorderSide(color: BrandColors.red),
        borderRadius: BorderRadius.circular(5.0),
      );
    }

    InputBorder get defaultBorder {
      return OutlineInputBorder(
        borderSide: BorderSide(color: BrandColors.blueGrey),
        borderRadius: BorderRadius.circular(5.0),
      );
    }

    EdgeInsets get contentPadding {
      return EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0);
    }

    Widget get prefixIcon {
      if (textFieldType == TextFieldType.search) {
        return Icon(Icons.search, color: BrandColors.darkBlueGrey);
      }
      return null;
    }

    Widget get suffixIcon {
      if (showClearOption) {
        return IconButton(icon: Icon(Icons.clear, color: BrandColors.darkBlueGrey), onPressed: () {
          if (controller != null) {
            controller.clear();
          }
        });
      }
      return null;
    }

    @override
    Widget build(BuildContext context) {
      return TextFormField(
        onSaved: onSaved,
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: textInputType,
        focusNode: focusNode,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onEditingComplete: onEditingComplete,
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: BrandColors.blueGrey,
          filled: true,
          labelText: title,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: defaultBorder,
          enabledBorder: defaultBorder,
          focusedBorder: defaultBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          contentPadding: contentPadding,
          hintText: hint,
        ),
      );
    }

}