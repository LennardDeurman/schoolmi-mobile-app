import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/models/data/attachment.dart';
import 'package:schoolmi/pages/photo.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentsContainer extends StatelessWidget {

  final List<Attachment> attachments;

  AttachmentsContainer ({this.attachments});

  @override
  Widget build(BuildContext context) {
    List<Widget> previews = [];
    for (int i = 0; i < attachments.length; i++) {
      double size = 50.0;
      if (attachments.length == 1) {
        size = 180.0;
      } else if (attachments.length == 2) {
        size = 80.0;
      }
      previews.add(Container(
        margin: EdgeInsets.only(bottom: 10),
        child: AttachmentPreview(
          attachments: attachments,
          attachmentIndex: i,
          size: size,
        ),
      ));
    }
    if (previews.length == 0) {
      return Container();
    }

    return Container(child: Wrap(children: previews));
  }

}


class AttachmentPreview extends StatelessWidget {
  final List<Attachment> attachments;
  final double size;
  final int attachmentIndex;

  AttachmentPreview({
    @required this.attachments,
    this.size = 50.0,
    this.attachmentIndex = 0
  });

  Attachment get previewAttachment {
    return this.attachments[this.attachmentIndex];
  }

  List<String> get attachmentsImageUrls { //Returns only the urls for images
    List<String> urls = [];
    attachments.forEach((Attachment attachment) {
      if (attachment.isImage) {
        urls.add(attachment.url);
      }
    });
    return urls;
  }

  Widget _buildPreview(Attachment attachment) {


    if (attachment.isImage) {
      return Container(child: Stack(
        children: <Widget>[
          Align(child: Container(
              child: Icon(Icons.image, color: BrandColors.blueGrey)
          ), alignment: Alignment.center),
          CachedNetworkImage(
            imageUrl: attachment.mini,
            fit: BoxFit.cover,
            width: size,
            height: size,
          )
        ],
      ), width: this.size, height: this.size, color: BrandColors.darkBlueGrey);
    } else {
      return  Container(child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: Container(child: RegularLabel(
            title: attachment.name,
            size: LabelSize.small,
            fontWeight: FontWeight.bold,
          ), color: BrandColors.blueGrey,  padding: EdgeInsets.all(10))),
          Container(
            width: 50,
            child: Icon(Icons.file_download, color: BrandColors.blue),
          )
        ],
      ), color: Colors.black12);
    }



  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        if (previewAttachment.isImage) {
          _onPreviewTapped(context);
        } else {
          if (await canLaunch(previewAttachment.url)) {
            await launch(previewAttachment.url);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: BrandColors.blueGrey),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: _buildPreview(previewAttachment),
        ),
      ),
    );
  }

  void _onPreviewTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PhotoViewPage(
          images: attachmentsImageUrls,
          startAtIndex: attachmentsImageUrls.indexOf(previewAttachment.url),
        ),
      ),
    );
  }
}
