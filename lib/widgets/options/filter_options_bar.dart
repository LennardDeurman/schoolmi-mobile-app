import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/network/models/options.dart';
import 'package:schoolmi/widgets/options/filter_options_bottomsheet.dart';
import 'package:schoolmi/widgets/options/options_box_picker.dart';

class FilterOptionsBar extends StatefulWidget {

  final OptionsBox typesOptionsBox;
  final OptionsBox orderOptionsBox;
  final FilterOptionsManager Function() optionsManagerBuilder;
  final Function(BuildContext, FilterOptionsManager) onApplyPressed;
  final Function shouldRefresh;

  FilterOptionsBar ({ this.typesOptionsBox, this.optionsManagerBuilder, this.orderOptionsBox, this.onApplyPressed, this.shouldRefresh, Key key }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return FilterOptionsBarState();
  }

}


class FilterOptionsBarState extends State<FilterOptionsBar> {

  String get title {
    return widget.typesOptionsBox.value.name;
  }

  bool get hasMultipleTypes {
    return widget.typesOptionsBox.optionsCount > 1;
  }


  void _showOptions(OptionsBox optionsBox) {
    OptionsBoxPicker(optionsBox).showOptionsPicker(context, (int position) {
      Navigator.pop(context);
      setState(() {
        optionsBox.selectedIndex = position;
      });

      if (widget.shouldRefresh != null) {
        widget.shouldRefresh();
      }

    });
  }

  void _showFilterOptions(BuildContext context, { Function(BuildContext, FilterOptionsManager) onApplyPressed }) {
    FilterOptionsManager filterOptionsManager = widget.optionsManagerBuilder();
    filterOptionsManager.showFilterOptions(context, onApplyPressed: onApplyPressed);
  }

  Widget _buildTitleWidget({ Color tintColor = Colors.black }) {
    return Container(
      child: Wrap(
        children: <Widget>[
          TitleLabel(
            title: title,
            size: TitleSize.small,
            color: tintColor,
          ),
          SizedBox(
            width: 10,
          ),
          Visibility(child: Icon(Icons.keyboard_arrow_down, color: tintColor), visible: hasMultipleTypes),
        ],
      ),
    );
  }

  Widget _buildTitleContainer() {
    if (!hasMultipleTypes) {
      return _buildTitleWidget();
    }

    return HighlightedWidget(
      renderWidget: (bool isHighlighted, Color color) {
        return _buildTitleWidget(tintColor: color);
      },
      baseColor: Colors.black,
      highlightedColor: BrandColors.blue,
      onPressed: () {
        _showOptions(widget.typesOptionsBox);
      },
    );
  }

  Widget _buildOrderContainer() {
    return HighlightedWidget(
      baseColor: Colors.black,
      renderWidget: (bool isHighlighted, Color color) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
                Localization().getValue(Localization().orderBy),
                style: TextStyle(
                    fontSize: 11,
                    color: color
                )
            ),
            Text(
                this.widget.orderOptionsBox.value.name,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.bold
                )
            )
          ],
        );
      },
      onPressed: () {
        _showOptions(widget.orderOptionsBox);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitleContainer(),
                SizedBox(height: 5),
                _buildOrderContainer()
              ],
            )
        ),
        Spacer(),
        HighlightedWidget(
          renderWidget: (bool isHighlighted, Color color) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10
                    ),
                    child: Text(
                      "Filteren ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color
                      ),
                    )
                  ),
                  Icon(
                    FontAwesomeIcons.filter,
                    color: color,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20
              ),
            );
          },
          onPressed: () {
            _showFilterOptions(context, onApplyPressed: (BuildContext context, FilterOptionsManager manager) {
              Navigator.pop(context);
              if (widget.onApplyPressed != null) {
                widget.onApplyPressed(context, manager);
              }

              if (widget.shouldRefresh != null) {
                widget.shouldRefresh();
              }
            });
          },
        )

      ],
    );
  }

}