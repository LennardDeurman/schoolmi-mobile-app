import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/button.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/widgets/message_container.dart';
import 'package:schoolmi/widgets/parsing_result_bar.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/listviews/advanced_listview.dart';
import 'package:schoolmi/models/base_object.dart';

abstract class ParserListView extends StatefulWidget {

  final NetworkParser parser;

  ParserListView (this.parser);

  @override
  State<StatefulWidget> createState();

}

abstract class ParserListViewState<T extends ParserListView> extends State<T> {


  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ParsingResult _parsingResult;

  Exception _exception;

  int paginationLimit = 20;

  set parsingResult (ParsingResult result) {
    setState(() {
      _parsingResult = result;
    });
  }

  ParsingResult get parsingResult {
    return _parsingResult;
  }

  int get sectionCount {
    return 1;
  }

  bool get isLoading {
    return widget.parser.downloadStatusInfo.downloadStatus == DownloadStatus.downloading;
  }

  bool get canLoadMore {
    if (_parsingResult != null) {
      return _parsingResult.objects.length % paginationLimit == 0 && _parsingResult.retrievedOnline; //If parsing result not retrieved online, then we cannot load more
    }
    return false;
  }

  Widget buildLoadMoreWidget() {
    return StreamBuilder<DownloadStatus>(builder: (BuildContext context, AsyncSnapshot<DownloadStatus> snapshot) {
      return Visibility(child: Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: DefaultButton(
              child: RegularLabel(title: Localization().getValue(Localization().loadMore)),
              isLoading: isLoading,
              onPressed: () {
                if (isLoading) {
                  return;
                }

                setState(() async {
                  ParsingResult resultToAppend = await widget.parser.download();
                  _parsingResult.appendResult(resultToAppend);
                });

              },
            )
        ),
      ), visible: canLoadMore);
    }, stream: widget.parser.downloadStatusInfo.downloadStatusStream);
  }

  Widget buildNoResultsBackground() {
    return MessageContainer(
        topWidget: SvgPicture.asset(AssetPaths.search, width: 80),
        title: Localization().getValue(Localization().noResults),
        subtitle: Localization().getValue(Localization().noMatchingResults)
    );
  }

  Widget buildLoadingBackground() {
    return MessageContainer(
      topWidget: CircularProgressIndicator(),
      title: Localization().getValue(Localization().busyLoading),
    );
  }

  Widget buildErrorBackground(Exception exception) {
    return MessageContainer(
        topWidget: SvgPicture.asset(AssetPaths.warning, width: 80),
        title: Localization().getValue(Localization().errorUnexpected),
        subtitle: Localization().getValue(Localization().errorUnexpectedShort)
    );
  }


  Widget buildBackground() {
    if (_parsingResult != null) {
      if (_parsingResult.objects.length == 0) {
        return buildNoResultsBackground();
      }
    } else if (isLoading) {
      return buildLoadingBackground();
    } else if (_exception != null) {
      return buildErrorBackground(_exception);
    }
    return Container();
  }

  Widget buildStatusBar() {
    return ParsingResultBar(this.parsingResult, isLoading: isLoading);
  }

  Widget buildListItem(BaseObject object);

  Widget buildHeader(int section) {
    if (section == 0) {
      return buildStatusBar();
    }
    return Container();
  }

  Widget buildFooter(int section) {
    return buildLoadMoreWidget();
  }

  Widget buildItem(BuildContext context, int index, int section) {
    var object = _parsingResult.objects[index];
    return buildListItem(object);
  }

  int numberOfRows (int section) {
    return _parsingResult.objects.length;
  }


  Widget buildListView() {
    return AdvancedListView.builder(
      headerBuilder: buildHeader,
      itemBuilder: buildItem,
      numberOfRows: numberOfRows,
      footerBuilder: buildFooter,
      sectionCount: sectionCount,
    );
  }

  Widget buildRefreshWidget() {
    Widget backgroundWidget = buildBackground();
    Widget listViewWidget = buildListView();
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: performRefresh,
      child: Stack(
        children: <Widget>[
          backgroundWidget,
          listViewWidget
        ],
      ),
    );
  }

  Future performRefresh() async {
    refreshIndicatorKey.currentState.show();
    parsingResult = await widget.parser.download().catchError((e) {
      showRefreshError(context);
    });
  }

  void showRefreshError(BuildContext context) {
    showSnackBar(message: Localization().getValue(Localization().errorUnexpectedShort), isError: true, buildContext: context);
  }

  void performLoad() {
    //First load the cached data if available, data can be not-updated, so don't allow
    widget.parser.loadCachedData().then((ParsingResult result) {
      parsingResult = result;
    }).catchError((e) {
      _exception = e;
    }).whenComplete(() {
      widget.parser.download().then((ParsingResult result) {
        parsingResult = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    performLoad();
  }

  @override
  Widget build(BuildContext context) {
    return buildRefreshWidget();
  }

}