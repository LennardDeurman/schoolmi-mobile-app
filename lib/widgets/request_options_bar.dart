import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:schoolmi/models/options.dart';

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


class RequestOptionsBarState extends State<RequestOptionsBar> {
  

  void _showOptionsPicker(OptionsBox optionsBox) {
    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: ListView.builder(itemBuilder: (BuildContext context, int position) {

            return HighlightedWidget(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  optionsBox.selectedIndex = position;
                });

                if (this.widget.onOptionsChanged != null) {
                  this.widget.onOptionsChanged(filterIndex: widget.filterOptionsBox.selectedIndex, orderIndex: widget.orderOptionsBox.selectedIndex);
                }

              }, baseColor: Colors.black,
              renderWidget: (bool highlighted, Color color) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RegularLabel(
                          title: optionsBox.stringAtIndex(position),
                          color: color,
                          fontWeight: optionsBox.selectedIndex == position ? FontWeight.bold : FontWeight.normal,
                        )
                      ),
                      Icon(Icons.chevron_right, color: BrandColors.darkBlueGrey)
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: BrandColors.blueGrey
                      )
                    )
                  ),
                );
              }
            );
          }, itemCount: optionsBox.optionsCount),
        );
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
                _showOptionsPicker(widget.filterOptionsBox);
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
            _showOptionsPicker(widget.orderOptionsBox);
          },
        )

      ],
    );
  }

}