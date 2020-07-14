import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/extensions/backgrounds.dart';
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

class FetcherListViewState<T extends FetcherListView, Z extends ParsableObject> extends State<T> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ListState<Z> listState = ListState();
  final SearchListState<Z> searchListState = SearchListState();

  @override
  void initState() {
    super.initState();
    searchListState.initialize(listState, refreshIndicatorKey);
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

