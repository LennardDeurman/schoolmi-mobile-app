import 'package:flutter/material.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/extensions/hyperlinks.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarBuilder {

  final TextEditingController _searchTextController = TextEditingController();
  final Function onDrawerButtonPressed;
  final Function onShowSearchPressed;
  final Function onMyProfilePressed;
  final Function onCancelSearchPressed;
  final Function(String search) onPerformSearchPressed;

  bool isSearch;

  Channel _channel;
  Profile _profile;

  HomeAppBarBuilder ({ @required this.onDrawerButtonPressed, @required this.onShowSearchPressed, @required this.onMyProfilePressed,
    @required this.onPerformSearchPressed, @required this.onCancelSearchPressed, this.isSearch = false
  }) {
    _channel = UserService().userResult.activeChannel;
    _profile = UserService().userResult.myProfile;
  }

  String get title {
    if (_channel != null) {
      return _channel.name;
    }
    return "";
  }

  Widget _buildProfileImage() {
    if (_profile != null) {
      return CircleImage.withAvatarObject(_profile);
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
          IconButton(
            icon: Container(child: _buildProfileImage(),
              width: 30,
              height: 30,
            ),
            onPressed: onMyProfilePressed,
          )
        ],
        title: TitleLabel(title: this.title, color: Colors.white)
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
                            onSubmitted: (value) {
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
                      child: Hyperlink(
                        baseColor: Colors.white,
                        highlightedColor: Colors.blueGrey,
                        builder: (bool isHighlighted, Color color) {
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