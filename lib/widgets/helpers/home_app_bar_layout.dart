import 'package:flutter/material.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/textfield.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarLayout {

  TextEditingController _searchTextController = TextEditingController();

  Function onDrawerButtonPressed;
  Function onShowSearchPressed;
  Function onMyProfilePressed;
  Function onCancelSearchPressed;
  Function(String search) onPerformSearchPressed;

  bool isSearch = false;

  HomeAppBarLayout ({ @required this.onDrawerButtonPressed, @required this.onShowSearchPressed, @required this.onMyProfilePressed,
    @required this.onPerformSearchPressed, @required this.onCancelSearchPressed, this.isSearch = false
  });




  String get title {
    if (UserService().hasActiveChannel) {
      return UserService().loginResult.activeChannel.name;
    }

    return "";
  }

  Widget _buildProfileImage() {
    var result = UserService().loginResult;
    if (result != null) {
      var myProfile = result.profile;
      if (myProfile != null) {
        return CircleImage.withAvatarObject(myProfile);
      }
    }

    return null;
  }

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(

      leading: Container(child: Center(child: RawMaterialButton(
        onPressed: onDrawerButtonPressed,
        child: SvgPicture.asset(AssetPaths.logo, width: 24),
        elevation: 0,
        padding: EdgeInsets.all(8),
        shape: new CircleBorder(),
        fillColor: BrandColors.blueGrey,
      ))),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: onShowSearchPressed,
        ),
          StreamBuilder<DownloadStatus>(
          builder: (BuildContext context, AsyncSnapshot<DownloadStatus> loginStatusSnapshot) {
            return IconButton(
              icon: Container(child: _buildProfileImage(),
                width: 30,
                height: 30,
              ),
              onPressed: onMyProfilePressed,
            );
          })

      ],
      title: StreamBuilder<DownloadStatus>(
          builder: (BuildContext context, AsyncSnapshot<DownloadStatus> loginStatusSnapshot) {
            return TitleLabel(title: this.title, color: Colors.white);
          })
    );
  }




  PreferredSizeWidget _buildSearchBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Expanded(
                  child: SafeArea(child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DefaultTextField(
                            hint: Localization().getValue(Localization().searchHint),
                            controller: _searchTextController,
                            showClearOption: true,
                            onSubmitted: () {
                              onPerformSearchPressed(_searchTextController.text);
                            },
                          )
                        ],
                      )
                  ))
              ),
              Container(
                  padding: EdgeInsets.only(
                      left: 10
                  ),
                  child: Center(
                      child: HighlightedWidget(
                        baseColor: Colors.white,
                        highlightedColor: Colors.blueGrey,
                        renderWidget: (bool isHighlighted, Color color) {
                          return RegularLabel(
                            size: LabelSize.small,
                            fontWeight: FontWeight.bold,
                            title: Localization().getValue(Localization().cancel),
                            color: color,
                            font: LabelFont.montserrat,
                          );
                        },
                        onPressed: onCancelSearchPressed,
                      )
                  )
              )
            ],
          ),
        ));
  }


  PreferredSizeWidget build() {
    if (this.isSearch) {
      return _buildSearchBar();
    } else {
      return _buildDefaultAppBar();
    }
  }

}