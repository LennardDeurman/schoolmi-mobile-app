import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/widgets/helpers/active_channel_layout.dart';
import 'package:schoolmi/widgets/helpers/home_app_bar_layout.dart';
import 'package:schoolmi/widgets/svg_icon.dart';
import 'package:schoolmi/widgets/channel_details_widget.dart';
import 'package:schoolmi/widgets/listviews/questions.dart';
import 'package:schoolmi/widgets/listviews/my_channels.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/parsers/questions.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class HomePage extends StatefulWidget {

  HomePage ();

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {

  HomeManager _homeManager = new HomeManager();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<QuestionsListViewState> _questionsListState = GlobalKey<QuestionsListViewState>();
  PageController _pageController = PageController();
  ValueNotifier _currentPageNotifier = ValueNotifier<int>(0);
  ActiveChannelLayout _activeChannelLayout;
  HomeAppBarLayout _homeAppBarLayout;


  @override
  void initState() {
    super.initState();

    _homeAppBarLayout = new HomeAppBarLayout(
        onDrawerButtonPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        onShowSearchPressed: () {
          setState(() {
            _homeAppBarLayout.isSearch = true;
          });
        },
        onMyProfilePressed: _onMyProfilePressed,
        onPerformSearchPressed: _onPerformSearchPressed,
        onCancelSearchPressed: () {
          setState(() {
            _homeAppBarLayout.isSearch = false;
          });
        }
    );

    _activeChannelLayout = new ActiveChannelLayout(_homeManager);
    _homeManager.initialize().then((InitializationResult initializationResult) {
      if (initializationResult == InitializationResult.serverConnectionError) {
        //show connection error dialog
      } else if (initializationResult == InitializationResult.noChannelAvailable) {
        //show channel picker
      }
    });
  }

  void _onPerformSearchPressed(String search) async {
    ParserWithQueryInfo parser = _questionsListState.currentState.widget.parser as ParserWithQueryInfo;
    parser.queryInfo = new QueryInfo(
      search: search
    );
    await _questionsListState.currentState.performRefresh();
  }

  void _onMyProfilePressed() {

  }

  void _onFabPressed() {

  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeManager>(
      model: _homeManager,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _homeAppBarLayout.build(),
        drawer: Drawer(
          child:  StreamBuilder<DownloadStatus>(builder: (BuildContext context, AsyncSnapshot<DownloadStatus> loginStatusSnapshot) {
            return Stack(
              children: <Widget>[
                PageView(
                    controller: _pageController,
                    children: () {
                      List<Widget> children = [];
                      if (UserService().hasActiveChannel) {
                        children.add(
                            ChannelDetailsWidget(UserService().loginResult.activeChannel,
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
            );
          }),
        ),
        body: _activeChannelLayout.build(builder: (Channel activeChannel) {
          QuestionsParser parser = new QuestionsParser(activeChannel);
          return QuestionsListView(parser, onQuestionPressed: _onQuestionPressed);
        }),
        floatingActionButton: StreamBuilder<DownloadStatus>(builder: (BuildContext context, AsyncSnapshot<DownloadStatus> loginStatusSnapshot) {
          return Visibility(child: FloatingActionButton(
            backgroundColor: BrandColors.blue,
            child: SvgIcon(
              assetUrl: AssetPaths.add,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: _onFabPressed,
          ), visible: UserService().hasActiveChannel);
        }, stream: _homeManager.loginRefreshManager.downloadStatusInfo.downloadStatusStream)
      ),
    );
  }




}