import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/managers/edit_channel.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/constants/routes.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/presenter.dart';

class ChannelSummaryPage extends StatelessWidget {


  final ChannelEditManager channelEditManager;

  ChannelSummaryPage (this.channelEditManager);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: TitleLabel(title: this.channelEditManager.uploadObject.name, color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName(Routes.home));
        },
      ),
      body: Container(child: ListView(
        children: <Widget>[
          BaseCell(
              columnWidgets: <Widget>[
                CircleImage.withAvatarObject(this.channelEditManager.uploadObject)
              ],
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: BrandColors.blueGrey
                  )
              )
          ),
          BaseCell(
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().name),
              ),
              RegularLabel(
                fontWeight: FontWeight.normal,
                title: this.channelEditManager.uploadObject.name,
              )
            ],
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),
          ),
          BaseCell(
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().description),
              ),
              RegularLabel(
                fontWeight: FontWeight.normal,
                title: this.channelEditManager.uploadObject.description,
              )
            ],
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),
          ),
          BaseCell(
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().public),
              )
            ],
            trailing: Container(child: RegularLabel(
              fontWeight: FontWeight.normal,
              title: this.channelEditManager.uploadObject.canPublicJoin ? Localization().getValue(Localization().yes) : Localization().getValue(Localization().no),
            ), padding: EdgeInsets.all(15)),
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),
          ),

          BaseCell(
              leading: SvgPicture.asset(AssetPaths.paperPlane, width: 20),
              onPressed: () {
                Presenter(context).showInvite(channelEditManager.uploadObject);
              },
              columnWidgets: <Widget>[
                RegularLabel(
                  fontWeight: FontWeight.bold,
                  title: Localization().getValue(Localization().sendInviteLink),
                ),
                SizedBox(
                  height: 4,
                ),
                RegularLabel(
                  fontWeight: FontWeight.normal,
                  title:Localization().getValue(Localization().sendInviteLinkExtra),
                )
              ],
              trailing: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.chevron_right,
                  color: BrandColors.grey,
                ),
              ),
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: BrandColors.blueGrey
                  )
              )
          ),

          BaseCell(
            leading: SvgPicture.asset(AssetPaths.classRoom, width: 20),
            onPressed: () {
              Presenter(context).showMembers(channelEditManager.uploadObject);
            },
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().members, usePluralForm: true),
              ),
              SizedBox(
                height: 4,
              ),
              RegularLabel(
                fontWeight: FontWeight.normal,
                title: Localization().getValue(Localization().membersExtra),
              ),
              SizedBox(
                height: 4,
              ),
              RegularLabel(
                  fontWeight: FontWeight.normal,
                  size: LabelSize.small,
                  title: Localization().buildNumberAndText(Localization().members, count: this.channelEditManager.uploadObject.membersCount)
              )
            ],
            trailing: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.chevron_right,
                color: BrandColors.grey,
              ),
            ),
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),

          ),
          BaseCell(
            leading: SvgPicture.asset(AssetPaths.tag, width: 20),
            onPressed: () {
              Presenter(context).showTags(channelEditManager.uploadObject);
            },
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().tags),
              ),
              SizedBox(
                height: 4,
              ),
              RegularLabel(
                fontWeight: FontWeight.normal,
                title: Localization().getValue(Localization().tagsInformationExtra),
              )
            ],
            trailing: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.chevron_right,
                color: BrandColors.grey,
              ),
            ),
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),

          )


        ],
      ), color: BrandColors.blueGrey),

    );
  }



}