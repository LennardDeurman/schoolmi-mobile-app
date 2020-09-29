import 'package:flutter/material.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/dialogs/userinfo.dart';
import 'package:schoolmi/widgets/extensions/backgrounds.dart';
import 'package:schoolmi/widgets/extensions/hyperlinks.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
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

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {

  final TextEditingController searchTextController = TextEditingController();
  final Function onDrawerButtonPressed;
  final Function onMyProfilePressed;
  final Function(String search) onPerformSearchPressed;

  final Channel channel;
  final Profile profile;

  final ValueNotifier<bool> searchStateNotifier;

  HomeAppBar ({ @required this.onDrawerButtonPressed, @required this.onMyProfilePressed,
    @required this.onPerformSearchPressed, @required this.channel, @required this.profile, this.searchStateNotifier
  });

  String get title {
    if (this.channel != null) {
      return this.channel.name;
    }
    return "";
  }

  PreferredSizeWidget defaultBar() {
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
          Visibility(
            visible: UserService().userResult.activeChannel != null,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                this.searchStateNotifier.value = true;
              },
            ),
          ),
          IconButton(
            icon: Container(child: () {
              if (profile != null) {
                return CircleImage.withAvatarObject(profile);
              }
              return null;
            }(),
              width: 30,
              height: 30,
            ),
            onPressed: onMyProfilePressed,
          )
        ],
        title: TitleLabel(title: this.title, color: Colors.white)
    );
  }

  PreferredSizeWidget searchBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DefaultTextField(
                            hint: Localization().getValue(Localization().searchHint),
                            controller: searchTextController,
                            showClearOption: true,
                            onSubmitted: (value) {
                              onPerformSearchPressed(searchTextController.text);
                            },
                          )
                        ],
                      )
                  )
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
                        onPressed: () {
                          searchStateNotifier.value = false;
                        },
                      )
                  )
              )
            ],
          ),
          margin: EdgeInsets.symmetric(
              horizontal: 10
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (searchStateNotifier.value) {
      return searchBar();
    } else {
      return defaultBar();
    }
  }

  @override
  Size get preferredSize {
    if (searchStateNotifier.value) {
      return Size.fromHeight(70);
    }
    return Size.fromHeight(kToolbarHeight);
  }


}



class HomePageState extends State<HomePage> {

  HomeManager _homeManager = HomeManager();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();
  ValueNotifier _currentPageNotifier = ValueNotifier<int>(0);
  ValueNotifier _searchStateNotifier = ValueNotifier<bool>(false);
  Presenter _presenter;


  @override
  void initState() {
    super.initState();

    _homeManager.userEventsHandler.registerAllEventListeners();

    _presenter = Presenter(context);

    _searchStateNotifier.addListener(() {
      setState(() {});
    });

    if (UserService().userResult.myProfile == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(context: context, builder: (context) {
          return UserInfoDialog();
        });
      });
    } else {
      _initialize();
    }

  }

  void _initialize() {
    InitializationResult initializationResult = _homeManager.initialize();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (initializationResult == InitializationResult.serverConnectionError) {
        _presenter.showConnectionError(_homeManager, _scaffoldKey);
      } else if (initializationResult == InitializationResult.noChannelAvailable) {
        _presenter.showChannelsIntro();
      }
    });

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

  Widget _body() {
    if (UserService().userResult.activeChannel == null) {
      return MessageContainer(
        title: Localization().getValue(Localization().selectAChannel),
        subtitle: Localization().getValue(Localization().selectAChannelSubtitle),
        customSubtitleSize: 16,
        topWidget: SvgPicture.asset(
          AssetPaths.classRoom,
          width: 150,
          height: 150,
        ),
      );
    } else {
      return Container(); //TODO: !! Implement the questions view
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeManager>(
      model: _homeManager,
      child: ScopedModelDescendant<HomeManager>(
        builder: (BuildContext context, Widget widget, HomeManager homeManager) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: HomeAppBar(
              searchStateNotifier: _searchStateNotifier,
              channel: UserService().userResult.activeChannel,
              profile: UserService().userResult.myProfile,
              onDrawerButtonPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
              onMyProfilePressed: _onMyProfilePressed,
              onPerformSearchPressed: _onPerformSearchPressed,
            ),
            body: _body(),
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
                    Visibility(
                      child: Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 20,
                        child: SafeArea(child: CirclePageIndicator(
                          itemCount: 2,
                          currentPageNotifier: _currentPageNotifier,
                        )),
                      ),
                      visible: UserService().userResult.activeChannel != null,
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