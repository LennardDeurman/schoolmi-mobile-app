import 'package:flutter/material.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/parsers/questions.dart';
import 'package:schoolmi/widgets/presenter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/helpers/active_channel_layout.dart';
import 'package:schoolmi/widgets/helpers/home_app_bar_layout.dart';
import 'package:schoolmi/widgets/listviews/questions.dart';
import 'package:schoolmi/widgets/channel_details_widget.dart';
import 'package:schoolmi/widgets/listviews/my_channels.dart';
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
  GlobalKey<QuestionsListViewState> _questionsListKey = GlobalKey<QuestionsListViewState>();
  PageController _pageController = PageController();
  ValueNotifier _currentPageNotifier = ValueNotifier<int>(0);
  HomeAppBarLayout _homeAppBarLayout;
  ActiveChannelLayout _activeChannelLayout;
  Presenter _presenter;


  @override
  void initState() {
    super.initState();

    _presenter = new Presenter(context);
    _activeChannelLayout = new ActiveChannelLayout(_homeManager);
    _homeAppBarLayout = new HomeAppBarLayout(
        onDrawerButtonPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        onShowSearchPressed: () {
          _questionsListKey.currentState.savePreSearchState();
          setState(() {
            _homeAppBarLayout.isSearch = true;
          });
        },
        onMyProfilePressed: () {
          _presenter.showMyProfile(_homeManager.profileManager);
        },
        onPerformSearchPressed: _onPerformSearchPressed,
        onCancelSearchPressed: _onSearchCancelled
    );

    _homeManager.initialize().then((InitializationResult initializationResult) {
      if (initializationResult == InitializationResult.serverConnectionError) {
        //show connection error dialog
      } else if (initializationResult == InitializationResult.noChannelAvailable) {
        //show channel picker
      }
    });


    UserService().loginResult.onChannelChange.listen((Channel channel) {
      _homeManager.questionsParser = QuestionsParser(channel);
      _questionsListKey.currentState.refreshIndicatorKey.currentState.show();
    });
  }



  void _onSearchCancelled() {
    _questionsListKey.currentState.recoverPreSearchState();
    setState(() {
      _homeAppBarLayout.isSearch = false;
    });
  }

  void _onPerformSearchPressed(String search) async {
    ParserWithQueryInfo parser = _questionsListKey.currentState.widget.parser as ParserWithQueryInfo;
    parser.queryInfo = new QueryInfo(
      search: search
    );
    _questionsListKey.currentState.refreshIndicatorKey.currentState.show();
  }

  void _onLeaveChannelPressed() {
    Navigator.pop(context);
    _homeManager.leaveChannel();
  }

  void _switchToChannel(Channel channel) {
    Navigator.pop(context);
    _homeManager.switchToChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeManager>(
      model: _homeManager,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _homeAppBarLayout.build(),
        drawer: Drawer(
          child: Stack(
            children: <Widget>[
              ScopedModelDescendant<HomeManager>(
                builder: (BuildContext context, Widget widget, HomeManager homeManager)  {
                  return PageView(
                      controller: _pageController,
                      children: () {
                        List<Widget> children = [];
                        if (UserService().loginResult.hasActiveChannel) {
                          children.add(
                              ChannelDetailsWidget(UserService().loginResult.activeChannel,
                                onEditChannelPressed: () {
                                  _presenter.showChannelEdit(homeManager, channel: UserService().loginResult.activeChannel);
                                },
                                onInvitePressed: () {
                                  _presenter.showInvite(UserService().loginResult.activeChannel);
                                },
                                onMembersPressed: () {
                                  _presenter.showMembers(_homeManager.channelDetailsManager.membersManager);
                                },
                                onNotificationSettingsPressed: _presenter.showNotifications,
                                onTagsPressed: () {
                                  _presenter.showTags(_homeManager);
                                },
                                onLeaveChannelPressed: _onLeaveChannelPressed,
                              )
                          );
                        }
                        children.add(MyChannelsListView(_homeManager,
                            onAddChannelPressed: () {
                              _presenter.showNewChannel(_homeManager);
                            },
                            onChannelPressed: _switchToChannel));
                        return children;
                      }(),
                      onPageChanged: (int index) {
                        _currentPageNotifier.value = index;
                      }
                  );
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
          ),
        ),
        body: ScopedModelDescendant<HomeManager>(
          builder: (BuildContext context, Widget widget, HomeManager homeManager) {
            return _activeChannelLayout.build(builder: (Channel channel) {
              _homeManager.questionsParser = QuestionsParser(channel);
              return QuestionsListView(_homeManager.questionsParser, key: _questionsListKey, onQuestionPressed: (Question question) {
                _presenter.showQuestion(_homeManager, question);
              });
            });
          }
        )
      ),
    );
  }




}