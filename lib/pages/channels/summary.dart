import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/extensions/presenter.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/managers/channels/edit.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/managers/channels/tags.dart';
import 'package:schoolmi/widgets/cells/base.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/localization/localization.dart';

class ChannelSummaryPage extends StatefulWidget {


  final ChannelEditManager channelEditManager;

  ChannelSummaryPage (this.channelEditManager);
  
  
  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
  
}

class ChannelSummaryPageState extends State<ChannelSummaryPage> {

  TagsManager _tagsManager;
  MembersManager _membersManager;

  @override
  void initState() {
    super.initState();

    _tagsManager = TagsManager(widget.channelEditManager.uploadObject);
    _membersManager = MembersManager(widget.channelEditManager.uploadObject);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: TitleLabel(title: widget.channelEditManager.uploadObject.name, color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: Container(child: ListView(
        children: <Widget>[
          Cell(
              columnWidgets: <Widget>[
                CircleImage.withAvatarObject(widget.channelEditManager.uploadObject)
              ],
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: BrandColors.blueGrey
                  )
              )
          ),
          Cell(
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().name),
              ),
              RegularLabel(
                fontWeight: FontWeight.normal,
                title: widget.channelEditManager.uploadObject.name,
              )
            ],
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),
          ),
          Cell(
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().description),
              ),
              RegularLabel(
                fontWeight: FontWeight.normal,
                title: widget.channelEditManager.uploadObject.description,
              )
            ],
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),
          ),
          Cell(
            columnWidgets: <Widget>[
              RegularLabel(
                fontWeight: FontWeight.bold,
                title: Localization().getValue(Localization().public),
              )
            ],
            trailing: Container(child: RegularLabel(
              fontWeight: FontWeight.normal,
              title: widget.channelEditManager.uploadObject.canPublicJoin ? Localization().getValue(Localization().yes) : Localization().getValue(Localization().no),
            ), padding: EdgeInsets.all(15)),
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            ),
          ),

          Cell(
              leading: SvgPicture.asset(AssetPaths.paperPlane, width: 20),
              onPressed: () {
                Presenter(context).showInvite(widget.channelEditManager.uploadObject);
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

          Cell(
            leading: SvgPicture.asset(AssetPaths.classRoom, width: 20),
            onPressed: () {
              Presenter(context).showMembers(_membersManager);
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
                  title: Localization().buildNumberAndText(Localization().members, count: widget.channelEditManager.uploadObject.membersCount)
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
          Cell(
            leading: SvgPicture.asset(AssetPaths.tag, width: 20),
            onPressed: () {
              Presenter(context).showTags(_tagsManager);
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