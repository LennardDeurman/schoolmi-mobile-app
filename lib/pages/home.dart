import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/dialogs/userinfo.dart';
import 'package:schoolmi/widgets/forms/userinfo.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:schoolmi/extensions/presenter.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/builders/home_app_bar.dart';
import 'package:schoolmi/widgets/lists/channels/my_channels.dart';
import 'package:schoolmi/widgets/channel_summary.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}



class HomePageState extends State<HomePage> {

  HomeManager _homeManager = HomeManager();
  HomeAppBarBuilder _homeAppBarBuilder;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();
  ValueNotifier _currentPageNotifier = ValueNotifier<int>(0);
  Presenter _presenter;


  @override
  void initState() {
    super.initState();

    _homeManager.userEventsHandler.registerAllEventListeners();

    _presenter = Presenter(context);

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

    if (UserService().userResult.myProfile == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(context: context, builder: (context) {
          return UserInfoDialog();
        });
      });
    } else {
      initialize();
    }

  }

  void initialize() {
    InitializationResult initializationResult = _homeManager.initialize();
    if (initializationResult == InitializationResult.serverConnectionError) {
      _presenter.showConnectionError(_homeManager, _scaffoldKey);
    } else if (initializationResult == InitializationResult.noChannelAvailable) {
      _presenter.showChannelsIntro();
    }
  }

  void _onPerformSearchPressed(String search) async {

  }

  void _onMyProfilePressed() {
    _presenter.showMyProfile(
      ProfileManager()
    );
  }

  void _onFabPressed() {

  }

  void _switchToChannel(Channel channel) {
    Navigator.pop(context);
    _homeManager.switchToChannel(channel);
  }

  void _onLeaveChannelPressed(Channel channel) {
    Navigator.pop(context);
    _homeManager.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeManager>(
      model: _homeManager,
      child: ScopedModelDescendant<HomeManager>(
        builder: (BuildContext context, Widget widget, HomeManager homeManager) {
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
                                ChannelSummary(
                                  onEditChannelPressed: () {
                                    _presenter.showChannelEdit(
                                        channel: UserService().userResult.activeChannel,
                                        onChannelEdit: _homeManager.switchToChannel
                                    );
                                  },
                                  onInvitePressed: () {
                                    //TODO: !!
                                  },
                                  onMembersPressed: () {
                                    _presenter.showMembers(_homeManager.membersManager);
                                  },
                                  onNotificationSettingsPressed: () {
                                    //TODO: !!
                                  },
                                  onTagsPressed: () {
                                    _presenter.showTags(_homeManager.tagsManager);
                                  },
                                  onLeaveChannelPressed: _onLeaveChannelPressed,
                                )
                            );
                          }
                          children.add(MyChannelsListView(
                              onAddChannelPressed: () {
                                _presenter.showNewChannel(
                                    onChannelEdit: _homeManager.switchToChannel,
                                    joinChannelFutureBuilder: (Channel channel) {
                                      return _homeManager.joinChannel(channel).then((channel) {
                                        showSnackBar(message: Localization().getValue(Localization().youAreMember), isError: true, buildContext: context);
                                      });
                                    }
                                );
                              },
                              onChannelPressed: _switchToChannel
                          ));
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
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _homeManager.userEventsHandler.unregisterAllEventListeners();
  }

}