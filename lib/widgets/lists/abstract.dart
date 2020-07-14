import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/extensions/backgrounds.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/lists/tableview.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/cache_protocol.dart';

abstract class FetcherListView<T extends ParsableObject> extends StatefulWidget {

  final Fetcher<T> fetcher;
  final CacheProtocol<T> cacheProtocol;

  FetcherListView (this.fetcher, { this.cacheProtocol, Key key }) : super(key: key);

  @override
  FetcherListViewState<FetcherListView, T> createState();

}

class FetchResultBar extends StatelessWidget {

  final ListState listState;


  FetchResultBar (this.listState);

  static String formatDate(DateTime dateTime) {
    DateFormat dateFormat = new DateFormat("d-MM-y HH:mm:ss", "nl");
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(
          strokeWidth: 2,
        )), visible: listState.isLoading),
        Visibility(child: SizedBox(
          width: 10,
        ), visible: listState.isLoading),
        Visibility(child: Text(
          Localization().buildWithParams(Localization().resultsRetrievedAt, [formatDate(listState.fetchResult.dateTime)]),
          style: TextStyle(
              fontSize: 12
          ),
        ), visible: listState.fetchResult != null)
      ],
    ), padding: EdgeInsets.symmetric(vertical: 8), color: BrandColors.blueGrey);
  }

}

class ListState<T extends ParsableObject> {

  bool _isLoading;
  Exception _exception;
  FetchResult<T> _fetchResult;

  int paginationLimit = 20;

  FetchResult<T> get fetchResult {
    return _fetchResult;
  }

  Exception get exception {
    return _exception;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get canLoadMore {
    if (_fetchResult != null)
      return _fetchResult.objects.length > 0 && _fetchResult.retrievedOnline && _fetchResult.objects.length % paginationLimit == 0;
    return false;
  }

  set isLoading (value) {
    _isLoading = value;
  }

  void complete(FetchResult<T> fetchResult) {
    _fetchResult = fetchResult;
  }

  void failWithError(e) {
    _exception = e;
  }

}

class SearchListState<T extends ParsableObject> {

  ListState<T> _listState;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  FetchResult<T> _preSearchFetchResult;

  SearchListState ();

  void initialize(ListState<T> listState, GlobalKey<RefreshIndicatorState> refreshIndicatorKey) {
    _listState = listState;
    _refreshIndicatorKey = refreshIndicatorKey;
  }

  void save() {
    _preSearchFetchResult = _listState.fetchResult;
  }

  void recover() {
    if (_preSearchFetchResult != null) {
      _listState.complete(_preSearchFetchResult);
    } else {
      _refreshIndicatorKey.currentState.show();
    }
  }

}

abstract class TableViewProviderProtocol<T extends ParsableObject>  {

  Widget rowBuilder(BuildContext context, int index, int section);

  Widget objectCellBuilder(T object);

  Widget sectionHeaderBuilder(int section);

  Widget sectionFooterBuilder(int section);

  int numberOfRows (int section);

  int get sectionCount {
    return 1;
  }

  TableViewBuilder provide();

}

class FetcherTableViewProvider<T extends ParsableObject> extends TableViewProviderProtocol<T> {

  final ListState<T> listState;
  final Function(T object) builder;
  final Function onLoadMorePressed;

  FetcherTableViewProvider (this.listState, { this.builder, this.onLoadMorePressed });

  Widget buildLoadMoreWidget() {
    return Visibility(child: Container(
      padding: EdgeInsets.all(20),
      child: Center(
          child: DefaultButton(
            child: RegularLabel(title: Localization().getValue(Localization().loadMore)),
            isLoading: listState.isLoading,
            onPressed: onLoadMorePressed,
          )
      ),
    ), visible: listState.canLoadMore);
  }

  Widget buildStatusBar() {
    return FetchResultBar(this.listState);
  }

  @override
  Widget sectionFooterBuilder(int section) {
    return buildLoadMoreWidget();
  }

  @override
  Widget sectionHeaderBuilder(int section) {
    if (section == 0) {
      return buildStatusBar();
    }
    return Container();
  }

  @override
  Widget objectCellBuilder(T object) {
    return this.builder(object);
  }

  @override
  int numberOfRows(int section) {
    return listState.fetchResult.objects.length;
  }

  @override
  Widget rowBuilder(BuildContext context, int index, int section) {
    var object = listState.fetchResult.objects[index];
    return objectCellBuilder(object);
  }

  @override
  TableViewBuilder provide() {
    return TableViewBuilder(
      itemBuilder: rowBuilder,
      sectionHeaderBuilder: sectionHeaderBuilder,
      sectionFooterBuilder: sectionFooterBuilder,
      numberOfRows: numberOfRows,
      sectionCount: sectionCount
    );
  }

}

abstract class FetcherListViewState<T extends FetcherListView, Z extends ParsableObject> extends State<T> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ListState<Z> listState = ListState();
  final SearchListState<Z> searchListState = SearchListState();

  FetcherTableViewProvider _tableViewProvider;

  @override
  void initState() {
    super.initState();
    searchListState.initialize(listState, refreshIndicatorKey);
    _tableViewProvider = tableViewProvider();
  }

  Widget objectCellBuilder(Z object);

  FetcherTableViewProvider tableViewProvider() {
    return FetcherTableViewProvider<Z>(listState, builder: (object) {
      return objectCellBuilder(object);
    });
  }

  void loadFuture(Future future) {
    listState.isLoading = true;
    future.whenComplete(() {
      listState.isLoading = false;
    });
  }

  void showRefreshError(BuildContext context) {
    showSnackBar(message: Localization().getValue(Localization().errorUnexpectedShort), isError: true, buildContext: context);
  }

  Future performInitialLoad() async {
    loadFuture(widget.fetcher.download().then((value) {
      listState.complete(value);
    }).catchError((e) {
      listState.failWithError(e);
    }));
  }

  Future performRefresh() async {
    loadFuture(widget.fetcher.download().then((value) {
      listState.complete(value);
    }).catchError((e) {
      showRefreshError(context);
    }));
  }

  Widget buildBackground() {
    if (listState.fetchResult != null && listState.fetchResult.objects.length == 0) {
      return ListBackgrounds.buildNoResultsBackground();
    } else if (listState.isLoading) {
      return ListBackgrounds.buildLoadingBackground();
    } else if (listState.exception != null) {
      return ListBackgrounds.buildErrorBackground(listState.exception);
    }
    return Container();
  }

  Widget buildListView() {
    if (listState.fetchResult == null) {
      return ListView(); //Dummy listview to make sure refresh indicator is correctly working
    }

    return TableView(
      _tableViewProvider.provide()
    );
  }


  Widget buildRefreshWidget() {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: performRefresh,
      child: Stack(
        children: <Widget>[
          buildBackground(),
          buildListView()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildRefreshWidget();
  }
}

