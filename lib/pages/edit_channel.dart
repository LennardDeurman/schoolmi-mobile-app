import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/pages/channel_summary.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/cells/list_item.dart';
import 'package:schoolmi/widgets/button.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/file_selector.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/managers/edit_channel.dart';
import 'package:schoolmi/managers/upload.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/textfield.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

class ChannelEditPage extends StatefulWidget {

  final Channel channel;
  final HomeManager homeManager;

  ChannelEditPage (this.homeManager, { this.channel }); //If channel is provided, update mode

  @override
  State<StatefulWidget> createState() {
    return _ChannelEditPage();
  }

}

class _ChannelEditPage extends State<ChannelEditPage> {


  GlobalKey<FormState> _channelFormKey = GlobalKey<FormState>();
  ChannelEditManager _channelEditManager;

  @override
  void initState() {
    super.initState();

    _channelEditManager = new ChannelEditManager(
      widget.homeManager,
      channel: this.widget.channel
    );
  }


  Widget _buildTextBox ({ String title, String subtitle, Function(String) onSaved, String hint, int maxLines = 1}) {
    return Column(
      children: <Widget>[
        TitleLabel(
          title: title,
        ),
        Visibility(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: RegularLabel(
              title: subtitle,
              size: LabelSize.regular,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: DefaultTextField(
            onSaved: onSaved,
            validator: Validators.notEmptyValidator,
            hint: hint,
            maxLines: maxLines,
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      color: BrandColors.blue,
      child: SafeArea(child: Container(
        width: double.infinity,
        child: ScopedModelDescendant<ChannelEditManager>(
            builder: (BuildContext context, Widget widget, ChannelEditManager manager) {
              return ScopedModelDescendant<UploadManager>(
                  builder: (BuildContext context, Widget child, UploadManager uploadManager) {
                    return DefaultButton(
                      child: RegularLabel(title: Localization().getValue(Localization().next)),
                      isLoading: uploadManager.isLoading || manager.isLoading,
                      onPressed: _nextButtonPressed,
                    );
                  }
              );
            }
        ),
      )),
    );
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModel<ChannelEditManager>(
      model: _channelEditManager,
      child: ScopedModel<UploadManager>(
        model: _channelEditManager.avatarImageUploadManager,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: BrandColors.blue,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                    child: Form(
                      key: _channelFormKey,
                      child: ListView(
                        children: <Widget>[
                          _buildTextBox(
                              title: Localization().getValue(Localization().chooseChannelName),
                              subtitle: Localization().getValue(Localization().chooseChannelNameDescription),
                              hint: Localization().getValue(Localization().chooseChannelNameHint),
                              onSaved: (String value) {
                                _channelEditManager.uploadObject.name = value;
                              }
                          ),
                          _buildTextBox(
                              title: Localization().getValue(Localization().addChannelDescriptionTitle),
                              subtitle: Localization().getValue(Localization().addChannelDescription),
                              hint: Localization().getValue(Localization().addChannelDescriptionHint),
                              onSaved: (String value) {
                                _channelEditManager.uploadObject.description = value;
                              }
                          ),
                          ListItem(
                              trailing: DefaultButton(
                                child: RegularLabel(title: Localization().getValue(Localization().changeProfilePicture)),
                                onPressed: () {

                                  FileSelector fileSelector = FileSelector(onFilesSelected: (List<File> files) {
                                    _channelEditManager.avatarImageUploadManager.upload(files.first).catchError((e) {
                                      showSnackBar(message: Localization().getValue(Localization().imageUploadError), buildContext: context, isError: true);
                                    });
                                  }, context: context);
                                  fileSelector.openFilePicker();

                                },
                              ),
                              leading: ScopedModelDescendant<UploadManager>(builder: (BuildContext context, Widget widget, UploadManager manager) {
                                return CircleImage(
                                    imageUrl: _channelEditManager.avatarImageUploadManager.presentingUrl,
                                    firstLetter: _channelEditManager.uploadObject.firstLetter,
                                    avatarColor: BrandColors.avatarColor(index: _channelEditManager.uploadObject.colorIndex)
                                );
                              }),
                              contentPadding: EdgeInsets.all(20)
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: TitleLabel(
                                title: Localization().getValue(Localization().everyMemberCanAddTags),
                              )),
                              Switch(
                                  value: _channelEditManager.uploadObject.canAddTags,
                                  onChanged: (bool value) {
                                    _channelEditManager.uploadObject.canAddTags = value;
                                  }
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: TitleLabel(
                                title: Localization().getValue(Localization().openChannel),
                              )),
                              Switch(
                                  value: _channelEditManager.uploadObject.canPublicJoin,
                                  onChanged: (bool value) {
                                    _channelEditManager.uploadObject.canPublicJoin = value;
                                  }
                              )
                            ],
                          )

                        ],
                      ),
                    )
                ),
                _buildSubmitButton()
              ],
            ),
            backgroundColor: Colors.white)
      ),
    );
  }

  void _nextButtonPressed() {
    if (!_channelFormKey.currentState.validate()) return;
    _channelFormKey.currentState.save();



    _channelEditManager.saveUploadObjects().then((_) {
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return ChannelSummaryPage(_channelEditManager);
          }
      ));
    }).catchError((e) {
      showSnackBar(buildContext: context, message: Localization().getValue(Localization().errorUnexpectedShort), isError: true);
    });


  }

}