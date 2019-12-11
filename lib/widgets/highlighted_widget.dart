import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class HighlightedWidget extends StatefulWidget {

  final Color baseColor;
  final Color highlightedColor;
  final Color selectedColor;
  final bool selected;
  final VoidCallback onPressed;
  final Function(bool isHighlighted, Color currentColor) renderWidget;

  HighlightedWidget ({this.baseColor = BrandColors.grey, Key key, this.renderWidget, this.selectedColor = BrandColors.blue, this.selected = false, @required this.onPressed, this.highlightedColor = BrandColors.darkBlueGrey}) :
      super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HighlightedWidgetState();
  }

  Widget buildWidget(bool highlighted, Color currentColor) {
    if (this.renderWidget != null) {
      return this.renderWidget(highlighted, currentColor);
    }
    return null;
  }

}

//This is not a private state because it needs to be modified by other classes (votes), in case a reset is required

class HighlightedWidgetState extends State<HighlightedWidget> {

  Color _currentColor;
  bool _highlighted;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    highlighted = false;
  }

  set highlighted (bool value) {
    _highlighted = value;
    _currentColor = value ? widget.highlightedColor : (widget.selected ? widget.selectedColor : widget.baseColor);
  }

  bool get highlighted {
    return _highlighted;
  }

  set selected (bool value) {
    _currentColor = value ? widget.selectedColor : widget.baseColor;
  }

  Color get currentColor {
    return _currentColor;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.buildWidget(highlighted, currentColor),
      onTapDown: (e) {
        setState(() {
          highlighted = true;
        });
      },
      onTapUp: (e) {
        setState(() {
          highlighted = false;
        });
      },
      onTap: () {
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          highlighted = false;
        });
      },
    );
  }
}

class HighlightedIcon extends HighlightedWidget {

  final IconData iconData;

  HighlightedIcon ({this.iconData, Key key, bool selected = false, Color baseColor = BrandColors.grey, @required VoidCallback onPressed, Color highlightedColor = BrandColors.darkBlueGrey})
  : super(baseColor: baseColor, onPressed: onPressed, highlightedColor: highlightedColor, selected: selected, key: key);

  @override
  Widget buildWidget(bool highlighted, Color currentColor) {
    return Icon(this.iconData, color: currentColor);
  }

}

class HighlightedText extends HighlightedWidget {

  final String title;

  HighlightedText ({this.title, Key key, bool selected = false, Color baseColor = BrandColors.grey, @required VoidCallback onPressed, Color highlightedColor = BrandColors.darkBlueGrey})
      : super(baseColor: baseColor, onPressed: onPressed, highlightedColor: highlightedColor, selected: selected, key: key);

  @override
  Widget buildWidget(bool highlighted, Color currentColor) {
    return RegularLabel(title: title, color: currentColor);
  }

}


