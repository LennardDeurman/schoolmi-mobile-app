import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/channels/edit.dart';
import 'package:schoolmi/managers/file_upload.dart';
import 'package:schoolmi/pages/channels/summary.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/file_selector.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';

class ChannelEditPage extends StatefulWidget {

  final Channel channel;
  final Function(Channel) onChannelEdited;

  ChannelEditPage ({ this.channel, this.onChannelEdited }); //If channel is provided, update mode

  @override
  State<StatefulWidget> createState() {
    return ChannelEditPageState();
  }

}

class ChannelEditPageState extends State<ChannelEditPage> {


  GlobalKey<FormState> _channelFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ChannelEditManager _channelEditManager;

  TextEditingController _channelNameTextController;
  TextEditingController _channelDescriptionTextController;

  @override
  void initState() {
    super.initState();

    _channelEditManager = new ChannelEditManager(
        channel: this.widget.channel
    );

    _channelDescriptionTextController = TextEditingController(
        text: _channelEditManager.uploadObject.description
    );

    _channelNameTextController = TextEditingController(
        text: _channelEditManager.uploadObject.name
    );
  }


  Widget _buildTextBox ({ String title, TextEditingController controller, String subtitle, Function(String) onSaved, String hint, int maxLines = 1}) {
    return Container(child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TitleLabel(
          title: title,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: RegularLabel(
            title: subtitle,
            size: LabelSize.regular,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        DefaultTextField(
          onSaved: onSaved,
          validator: Validators.notEmptyValidator,
          hint: hint,
          controller: controller,
          maxLines: maxLines,
        )
      ],
    ), padding: EdgeInsets.symmetric(
        vertical: 20
    ));
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      color: BrandColors.blue,
      child: SafeArea(child: Container(
        width: double.infinity,
        child: ScopedModelDescendant<ChannelEditManager>(
            builder: (BuildContext context, Widget widget, ChannelEditManager manager) {
              return ScopedModelDescendant<FileUploadManager>(
                  builder: (BuildContext context, Widget child, FileUploadManager uploadManager) {
                    return DefaultButton(

                      child: RegularLabel(title: Localization().getValue(Localization().next), color: Colors.white, fontWeight: FontWeight.bold, size: LabelSize.medium),
                      isLoading: manager.isLoading,
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
      child: ScopedModel<FileUploadManager>(
          model: _channelEditManager.avatarImageUploadManager,
          child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: BrandColors.blue,
              ),
              body: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            child: Form(
                              key: _channelFormKey,
                              child: ListView(
                                padding: EdgeInsets.all(20),
                                children: <Widget>[
                                  _buildTextBox(
                                      title: Localization().getValue(Localization().chooseChannelName),
                                      subtitle: Localization().getValue(Localization().chooseChannelNameDescription),
                                      hint: Localization().getValue(Localization().chooseChannelNameHint),
                                      controller: _channelNameTextController,
                                      onSaved: (String value) {
                                        _channelEditManager.uploadObject.name = value;
                                      }
                                  ),
                                  _buildTextBox(
                                      title: Localization().getValue(Localization().addChannelDescriptionTitle),
                                      subtitle: Localization().getValue(Localization().addChannelDescription),
                                      hint: Localization().getValue(Localization().addChannelDescriptionHint),
                                      controller: _channelDescriptionTextController,
                                      onSaved: (String value) {
                                        _channelEditManager.uploadObject.description = value;
                                      }
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        ScopedModelDescendant<FileUploadManager>(builder: (BuildContext context, Widget widget, FileUploadManager manager) {
                                          if (manager.isLoading) {
                                            return CircleAvatar(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  strokeWidth: 1,
                                                ),
                                              ),
                                              backgroundColor: BrandColors.blue,
                                            );
                                          } else {
                                            if (_channelEditManager.uploadObject.hasImage || _channelEditManager.avatarImageUploadManager.presentingUrl != null) {
                                              return CircleImage(
                                                imageUrl: _channelEditManager.avatarImageUploadManager.presentingUrl,
                                                firstLetter: _channelEditManager.uploadObject.firstLetter,
                                                avatarColor: BrandColors.avatarColor(index: _channelEditManager.uploadObject.colorIndex),
                                              );
                                            } else {
                                              return CircleAvatar(
                                                child: Icon(Icons.person, color: Colors.white),
                                                backgroundColor: BrandColors.blue,
                                              );
                                            }
                                          }

                                        }),
                                        Spacer(),
                                        DefaultButton(

                                          child: RegularLabel(title: Localization().getValue(Localization().changeProfilePicture), color: Colors.white, fontWeight: FontWeight.bold, size: LabelSize.regular),
                                          onPressed: () {

                                            FileSelector fileSelector = FileSelector(onFilesSelected: (List<File> files) {
                                              _channelEditManager.avatarImageUploadManager.upload(file: files.first).then((_) {
                                                _channelEditManager.uploadObject.imageUrl = _channelEditManager.avatarImageUploadManager.presentingUrl;
                                              }).catchError((e) {
                                                showSnackBar(message: Localization().getValue(Localization().imageUploadError), scaffoldKey: _scaffoldKey, isError: true);
                                              });
                                            }, context: context);
                                            fileSelector.openFilePicker();

                                          },
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: TitleLabel(
                                        title: Localization().getValue(Localization().everyMemberCanAddTags),
                                      )),
                                      Switch(
                                          value: _channelEditManager.uploadObject.canAddTags,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _channelEditManager.uploadObject.canAddTags = value;
                                            });
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
                                            setState(() {
                                              _channelEditManager.uploadObject.canPublicJoin = value;
                                            });
                                          }
                                      )
                                    ],
                                  )

                                ],
                              ),
                            )
                        )
                    ),
                    _buildSubmitButton()
                  ],
                ),
              ),
              backgroundColor: Colors.white)
      ),
    );
  }

  void _nextButtonPressed() {
    if (!_channelFormKey.currentState.validate()) return;
    _channelFormKey.currentState.save();



    _channelEditManager.saveUploadObject().then((editedChannel) {

      if (this.widget.onChannelEdited != null)
        this.widget.onChannelEdited(editedChannel);

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