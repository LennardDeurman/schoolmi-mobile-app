import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/widgets/cells/tag.dart';
import 'package:schoolmi/localization/localization.dart';


class QuestionCell extends StatelessWidget {

  final Question question;
  final Function(Question) onPressed;

  QuestionCell ({@required this.question, this.onPressed});

  Widget _buildBox(String label, String value, {Border border, Color backgroundColor = Colors.transparent, Color valueColor = BrandColors.black, Color labelColor = BrandColors.blueGrey}) {
    return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TitleLabel(
            title: value,
            size: TitleSize.regular,
            color: valueColor,
          ),
          TitleLabel(
            title: label,
            size: TitleSize.extraSmall,
            color: labelColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersBox() {
    String label = Localization().buildNumberAndText(Localization().answers, excludeNumber: true, count: question.answerCount);

    if (question.hasCheckedAnswer) {
      return _buildBox(label, question.answerCount.toString(),
          border: Border.all(color: BrandColors.lightGreen, width: 1.0),
          backgroundColor: BrandColors.lightGreen,
          valueColor: Colors.white,
          labelColor: Colors.white
      );
    } else {
      return _buildBox(label, question.answerCount.toString(),
          border: Border.all(color: BrandColors.blue, width: 1.0),
          valueColor:  BrandColors.blue,
          labelColor: BrandColors.blue
      );
    }


  }

  Widget _buildVotesBox() {


    String label = Localization().buildNumberAndText(Localization().votes, excludeNumber: true, count: question.votesInfo.vote);
    return _buildBox(label, question.votesInfo.vote.toString(),
        border: Border.all(color: Colors.transparent, width: 1.0),
        valueColor:  BrandColors.black,
        labelColor: BrandColors.black
    );

  }



  Widget _buildTags() {
    List<Widget> tagsList = [];
    question.tags.forEach((tag) {
      tagsList.add(TagCell(title: tag.name ?? "", color: BrandColors.avatarColor(index: tag.colorIndex)));
    });
    if (tagsList.length > 0) {
      return Container(
        child: Wrap(children: tagsList),
        margin: EdgeInsets.symmetric(vertical: 5),
      );
    }
    return Container();

  }

  Widget _buildNotifyItem({IconData iconData, String title, Color iconColor}) {
    return Row(
      children: <Widget>[
        Icon(iconData, size: 15, color: iconColor),
        SizedBox(width: 4),
        Container(
            child: RegularLabel(
              title: title,
              size: LabelSize.small,
              font: LabelFont.lato,
              fontWeight: FontWeight.bold,
              color: iconColor,
            )
        )

      ],
    );
  }

  List<Widget> _buildNotifyItems() {
    List<Widget> widgets = [];
    if (question.flagged || question.parentFlagged) {
      widgets.add(_buildNotifyItem(
          iconData: Icons.warning,
          iconColor: Color.fromRGBO(255, 140, 0, 1),
          title: Localization().getValue(question.flagged ? Localization().reported : Localization().activityReported)
      ));
      widgets.add(SizedBox(width: 10));
    }
    if (question.isDeleted) {
      widgets.add(_buildNotifyItem(
          iconData: Icons.delete,
          iconColor: BrandColors.red,
          title: Localization().getValue(Localization().deleted)
      ));
      widgets.add(SizedBox(width: 10));
    }

    if (question.duplicated) {
      widgets.add(_buildNotifyItem(
          iconData: Icons.content_copy,
          iconColor: BrandColors.darkBlueGrey,
          title: Localization().getValue(Localization().markedDuplicated)
      ));
      widgets.add(SizedBox(width: 10));
    }



    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Material(child: InkWell(child: Container(child: Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        RegularLabel(
                          fontWeight: FontWeight.bold,
                          font: LabelFont.montserrat,
                          size: LabelSize.small,
                          color: Colors.grey,
                          title: question.viewCount.toString(),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        RegularLabel(
                          fontWeight: FontWeight.w400,
                          font: LabelFont.montserrat,
                          size: LabelSize.small,
                          title: Localization().buildNumberAndText(Localization().views, excludeNumber: true, count: question.viewCount)
                        ),

                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 5),
                  ),
                  Container(
                    child: TitleLabel(
                      title: question.title,
                      size: TitleSize.small,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5),
                  ),
                  _buildTags(),
                  Wrap(
                    children: <Widget>[
                      RegularLabel(
                        title: "Geplaatst op: " + Dates.format(question.dateAdded, format: Dates.friendlyFormat),
                        color: BrandColors.grey,
                        size: LabelSize.small,
                      ),
                      RegularLabel(
                        title: " door ",
                        color: BrandColors.grey,
                        size: LabelSize.small,
                      ),
                      RegularLabel(
                        title: question.profile != null ? question.profile.fullName : "",
                        color: BrandColors.blue,
                        size: LabelSize.small,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: _buildNotifyItems(),
                    )
                  )

                ],
              ),
              margin: EdgeInsets.only(
                right: 10
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Visibility(
                  visible: !question.isSeen,
                  child: Icon(Icons.mail, size: 16, color: BrandColors.blue),
                ),
                _buildVotesBox(),
                _buildAnswersBox(),
                SizedBox(height: 10),
                Icon(Icons.star, size: 18, color: BrandColors.darkBlueGrey)


              ],
            ),
          )
        ],
      ),
      padding: EdgeInsets.all(20),
    )), onTap: () {
      onPressed(question);
    }), color: Colors.transparent), decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BrandColors.blueGrey
            )
        )
    ));

  }

}