import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/widgets/builders/home_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}



class _HomePageState extends State<HomePage> {


  HomeManager _homeManager = HomeManager();
  HomeAppBarBuilder _homeAppBarBuilder;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();
  ValueNotifier _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _homeManager.userEventsHandler.registerAllEventListeners();

    InitializationResult initializationResult = _homeManager.initialize();
    if (initializationResult == InitializationResult.serverConnectionError) {
      //TODO: show connection error dialog
    } else if (initializationResult == InitializationResult.noChannelAvailable) {
      //TODO: show channel picker
    }

    _homeAppBarBuilder = new HomeAppBarBuilder(
        onDrawerButtonPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        onShowSearchPressed: () {
          setState(() {
            _homeAppBarBuilder.isSearch = true;
          });
        },
        onMyProfilePressed: _onMyProfilePressed,
        onPerformSearchPressed: _onPerformSearchPressed,
        onCancelSearchPressed: () {
          setState(() {
            _homeAppBarBuilder.isSearch = false;
          });
        }
    );


  }

  void _onPerformSearchPressed(String search) async {

  }

  void _onMyProfilePressed() {

  }

  void _onFabPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _homeAppBarBuilder.build(),
      drawer: Drawer(
        child: Stack(
          children: <Widget>[
            PageView(
                controller: _pageController,
                children: () {
                  List<Widget> children = [];
                  if (UserService().userResult.activeChannel != null) {
                    children.add(
                        ChannelDetailsWidget(UserService().userResult.activeChannel,
                          onEditChannelPressed: _onEditChannelPressed,
                          onInvitePressed: _onInvitePressed,
                          onMembersPressed: _onMembersPressed,
                          onNotificationSettingsPressed: _onNotificationSettingsPressed,
                          onTagsPressed: _onTagsPressed,
                          onLeaveChannelPressed: _onLeaveChannelPressed,
                        )
                    );
                  }
                  children.add(MyChannelsListView(UserService().myChannelsParser, onAddChannelPressed: _onAddChannelPressed, onChannelPressed: _onChannelPressed));
                  return children;
                }(),
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                }
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: SafeArea(child: CirclePageIndicator(
                itemCount: 2,
                currentPageNotifier: _currentPageNotifier,
              )),
            )
          ],
        )
      ),
      floatingActionButton: Visibility(
        visible: UserService().userResult.activeChannel != null,
        child: FloatingActionButton(
          backgroundColor: BrandColors.blue,
          child: SvgPicture.asset(
              AssetPaths.add,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              color: Colors.white
          ),
          onPressed: _onFabPressed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _homeManager.userEventsHandler.unregisterAllEventListeners();
  }

}