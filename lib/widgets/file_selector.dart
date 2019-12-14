import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';

class FileSelector {
  Function(List<File>) onFilesSelected;
  BuildContext context;
  bool allowFiles;
  bool allowMultipleFiles;

  FileSelector({
    @required this.onFilesSelected,
    @required this.context,
    this.allowFiles = false,
    this.allowMultipleFiles = false
  });

  Widget _buildGrabber() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: 50.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: BrandColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
    );
  }


  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 25.0),
      child: TitleLabel(title: Localization().getValue(allowFiles ? Localization().filePicker : Localization().imagePicker)),
    );
  }

  Widget _buildUseCamera() {
    return FlatButton(
      onPressed: () {
        ImagePicker.pickImage(source: ImageSource.camera).then((File file) {
          if (file != null) {
            onFilesSelected(List.from([file]));
          }
          Navigator.pop(context);
        });
      },
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.camera, color: BrandColors.lightGrey),
          SizedBox(width: 10.0),
          RegularLabel(title: Localization().getValue(Localization().imagePickerCamera))
        ],
      ),
    );
  }

  void _pickFiles({FileType fileType:FileType.ANY}) {
    if (allowMultipleFiles) {
      FilePicker.getMultiFile(type: fileType).then((List<File> files) {
        onFilesSelected(files);
        Navigator.pop(context);
      });
    } else {
      FilePicker.getFile(type: fileType).then((File file) {
        onFilesSelected([file]);
        Navigator.pop(context);
      });
    }
  }

  Widget _buildUseFiles() {
    return FlatButton(
      onPressed: () {
        _pickFiles();
      },
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.file, color: BrandColors.lightGrey),
          SizedBox(width: 10.0),
          RegularLabel(title: Localization().getValue(Localization().filePickerAny))
        ],
      ),
    );
  }

  Widget _buildUseGallery() {
    return FlatButton(
      onPressed: () {
        ImagePicker.pickImage(source: ImageSource.gallery).then((File file) {
          if (file != null) {
            onFilesSelected(List.from([file]));
          }
          Navigator.pop(context);
        });
      },
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.image, color: BrandColors.lightGrey),
          SizedBox(width: 10.0),
          RegularLabel(title: Localization().getValue(Localization().imagePickerGallery))
        ],
      ),
    );
  }

  void openFilePicker() {
    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildGrabber(),
              _buildTitle(),
              _buildUseCamera(),
              Divider(),
              _buildUseGallery(),
              Visibility(
                visible: this.allowFiles,
                child: Divider(),
              ),
              Visibility(
                visible: this.allowFiles,
                child: _buildUseFiles(),
              )
            ],
          ),
        );
      },
    );
  }
}
