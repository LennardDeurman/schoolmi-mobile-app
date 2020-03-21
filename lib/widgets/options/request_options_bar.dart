import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/models/options.dart';
import 'package:schoolmi/widgets/options/options_bar_state.dart';

class RequestOptionsBar extends StatefulWidget {

  final OptionsBox filterOptionsBox;
  final OptionsBox orderOptionsBox;
  final Function onOptionsChanged;

  RequestOptionsBar (this.filterOptionsBox, this.orderOptionsBox, { this.onOptionsChanged, Key key }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return RequestOptionsBarState();
  }

}



class RequestOptionsBarState extends OptionsBarState<RequestOptionsBar> {

  void _showOptions(OptionsBox optionsBox) {
    showOptionsPicker(optionsBox, (int option) {
      if (this.widget.onOptionsChanged != null) {
        int filterIndex = widget.filterOptionsBox.selectedIndex;
        int orderIndex = widget.orderOptionsBox.selectedIndex;
        this.widget.onOptionsChanged(filterIndex: filterIndex, orderIndex: orderIndex);
      }
    });
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
            child: HighlightedWidget(
              renderWidget: (bool isHighlighted, Color color) {
                return Container(
                  child: Wrap(
                    children: <Widget>[
                      TitleLabel(
                        title: widget.filterOptionsBox.value.name,
                        size: TitleSize.small,
                        color: color,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.keyboard_arrow_down, color: color)
                    ],
                  ),
                );
              },
              baseColor: Colors.black,
              highlightedColor: BrandColors.blue,
              onPressed: () {
                _showOptions(widget.filterOptionsBox);
              },
            )
        ),
        Spacer(),
        HighlightedWidget(
          renderWidget: (bool isHighlighted, Color color) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.orderOptionsBox.name,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                      widget.orderOptionsBox.value.name,
                      style: TextStyle(
                          fontSize: 10
                      )
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20
              ),
            );
          },
          onPressed: () {
            _showOptions(widget.orderOptionsBox);
          },
        )

      ],
    );
  }

}