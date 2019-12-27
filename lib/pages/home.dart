import 'package:flutter/material.dart';
import 'package:schoolmi/network/parsers/questions.dart';
import 'package:schoolmi/widgets/presenter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/widgets/helpers/active_channel_layout.dart';
import 'package:schoolmi/widgets/helpers/home_app_bar_layout.dart';
import 'package:schoolmi/widgets/listviews/questions.dart';
import 'package:schoolmi/models/data/channel.dart';

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
          setState(() {
            _homeAppBarLayout.isSearch = true;
          });
        },
        onMyProfilePressed: _presenter.showMyProfile,
        onPerformSearchPressed: _onPerformSearchPressed,
        onCancelSearchPressed: () {
          setState(() {
            _homeAppBarLayout.isSearch = false;
          });
        }
    );

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


  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeManager>(
      model: _homeManager,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _homeAppBarLayout.build(),
        drawer: Drawer(),
        body: _activeChannelLayout.build(builder: (Channel channel) {
          _homeManager.questionsParser = QuestionsParser(channel);
          return QuestionsListView(_homeManager.questionsParser, onQuestionPressed: _presenter.showQuestion);
        })
      ),
    );
  }




}