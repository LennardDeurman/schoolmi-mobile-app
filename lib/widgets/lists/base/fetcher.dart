import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/extensions/backgrounds.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/lists/base/tableview.dart';
import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/fetcher.dart';


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

abstract class ListActionsDelegate {

  final ListState listState;
  final BuildContext context;

  ListActionsDelegate (this.listState, this.context);

  Future loadMore();

  Future performInitialLoad();

  Future performRefresh();

  void onRefreshError(e) {
    showSnackBar(message: Localization().getValue(Localization().errorUnexpectedShort), isError: true, buildContext: context);
  }

  void onLoadMoreError(e) {
    showSnackBar(message: Localization().getValue(Localization().errorUnexpectedShort), isError: true, buildContext: context);
  }

  void loadFuture(Future future) {
    listState.isLoading = true;
    future.whenComplete(() {
      listState.isLoading = false;
    });
  }

}

class DefaultFetcherListActionsDelegate extends ListActionsDelegate {

  final Fetcher fetcher;
  final Function preRefresh;
  final Function preInitialLoad;

  DefaultFetcherListActionsDelegate (ListState listState, BuildContext context, this.fetcher, { this.preRefresh, this.preInitialLoad }) : super(listState, context);

  @override
  Future loadMore() async {
    listState.listRequestParams.offset = listState.fetchResult.objects.length;
    loadFuture(
      fetcher.download(params: listState.listRequestParams).then((res) {
        this.listState.appendResult(res);
      }).catchError((e) {
        onLoadMoreError(e);
      })
    );
  }

  @override
  Future performInitialLoad() async {
    if (preInitialLoad != null) {
      preInitialLoad();
    }
    loadFuture(
      fetcher.download(params: listState.listRequestParams).then((res) {
        this.listState.complete(res);
      }).catchError((e) {
        this.listState.failWithError(e);
      })
    );
  }

  @override
  Future performRefresh() async {
    if (preRefresh != null) {
      preInitialLoad();
    }
    loadFuture(
      fetcher.download(params: listState.listRequestParams).then((res) {
        this.listState.complete(res);
      }).catchError((e) {
        onRefreshError(e);
      })
    );
  }


}



class ListState<T extends ParsableObject> extends Model {

  bool alwaysDisableLoadMore = false;
  ListRequestParams listRequestParams;

  bool _isLoading = false;
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

  int resolveIndexAndRemove(T object) {
    int indexOf = _fetchResult.objects.indexOf(object);
    _fetchResult.objects.removeAt(indexOf);
    return indexOf;
  }

  void restoreObjectAtIndex(int index, T object) {
    _fetchResult.objects.insert(index, object);
  }

  void complete(FetchResult<T> fetchResult) {
    _fetchResult = fetchResult;
    notifyListeners();
  }

  void appendResult(FetchResult<T> fetchResult) {
    _fetchResult.appendResult(fetchResult);
    notifyListeners();
  }

  void removeObjects(List<T> objects) {
    _fetchResult.objects.removeWhere((o) {
      return objects.contains(o);
    });
    notifyListeners();
  }

  void failWithError(e) {
    _exception = e;
    notifyListeners();
  }

  ListState();

  ListState.static({ bool isLoading, FetchResult<T> fetchResult }) {
    _isLoading = isLoading;
    _fetchResult = fetchResult;
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
    ), visible: listState.canLoadMore && !listState.alwaysDisableLoadMore);
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

abstract class FetcherListView<T extends ParsableObject> extends StatefulWidget {

  FetcherListView ({ Key key }) : super(key: key);

  @override
  FetcherListViewState<FetcherListView<T>, T> createState();

}




abstract class FetcherListViewState<T extends FetcherListView, Z extends ParsableObject> extends State<T> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ListState<Z> listState = ListState();
  final SearchListState<Z> searchListState = SearchListState();
  ListActionsDelegate actionsDelegate;

  FetcherTableViewProvider _tableViewProvider;



  @override
  void initState() {
    super.initState();
    searchListState.initialize(listState, refreshIndicatorKey);
    listState.listRequestParams = listRequestParams();
    _tableViewProvider = tableViewProvider();
    actionsDelegate = listActionsDelegate();
    actionsDelegate.performInitialLoad();
  }

  Widget objectCellBuilder(Z object);

  ListActionsDelegate listActionsDelegate();

  ListRequestParams listRequestParams() {
    return ListRequestParams();
  }

  FetcherTableViewProvider tableViewProvider() {
    return FetcherTableViewProvider<Z>(listState, builder: (object) {
      return objectCellBuilder(object);
    }, onLoadMorePressed: () {
      if (listState.isLoading) {
        return;
      }

      actionsDelegate.loadMore();

    });
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
      onRefresh: actionsDelegate.performRefresh,
      child: ScopedModel<ListState>(
        model: this.listState,
        child: ScopedModelDescendant<ListState>(
          builder: (BuildContext context, Widget widget, ListState state) {
            return Stack(
              children: <Widget>[
                buildBackground(),
                buildListView()
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildRefreshWidget();
  }
}