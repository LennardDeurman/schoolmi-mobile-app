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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ChannelEditManager _channelEditManager;

  TextEditingController _channelNameTextController;
  TextEditingController _channelDescriptionTextController;

  @override
  void initState() {
    super.initState();

    _channelEditManager = new ChannelEditManager(
      widget.homeManager,
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
              return ScopedModelDescendant<UploadManager>(
                  builder: (BuildContext context, Widget child, UploadManager uploadManager) {
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
      child: ScopedModel<UploadManager>(
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
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _channelFormKey,
                          child: ListView(
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
                                    ScopedModelDescendant<UploadManager>(builder: (BuildContext context, Widget widget, UploadManager manager) {
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
                                          _channelEditManager.avatarImageUploadManager.upload(files.first).then((_) {
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