import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class PhotoViewPage extends StatefulWidget {
  final int startAtIndex;
  final List<String> images;
  PhotoViewPage({@required this.images, this.startAtIndex = 0});

  @override
  State<StatefulWidget> createState() {
    return _PhotoViewPageState();
  }
}

class _PhotoViewPageState extends State<PhotoViewPage> {

  PageController _pageController;
  List<PhotoViewGalleryPageOptions> _imageOptions;
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();

    _currentPage = 0;

    _pageController = PageController(initialPage: this.widget.startAtIndex);

    _imageOptions = widget.images.map((String image) {
      final option = PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(image),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      );
      return option;
    }).toList();

  }

  void _onPageChanged(int index) {
    _currentPage = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          PhotoViewGallery(
              pageController: _pageController,
              pageOptions: _imageOptions,
              onPageChanged: _onPageChanged,
              backgroundDecoration: BoxDecoration(
                color: Colors.white,
              ),
              gaplessPlayback: true
          ),
          Positioned(
            right: 15.0,
            top: 0.0,
            child: SafeArea(
              child: Chip(
                label: RegularLabel(
                  title: Localization().buildIndexString(Localization().getValue(Localization().image), _currentPage + 1, widget.images.length),
                ),
                deleteIcon: Icon(Icons.close, color: Colors.black),
                backgroundColor: Colors.white.withOpacity(0.60),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                onDeleted: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }










}
