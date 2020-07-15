import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/fetcher.dart';

abstract class SearchListViewState<T extends FetcherListView<Z>, Z extends ParsableObject> extends FetcherListViewState<T, Z> {

  final FocusNode searchTextFieldFocusNode = FocusNode();
  Fetcher<Z> _fetcher;




  String get searchHint {
    return Localization().getValue(Localization().search);
  }

  @override
  void initState() {
    super.initState();
    listState.alwaysDisableLoadMore = true;
  }

  //ListActionsDelegate
  @override
  ListActionsDelegate listActionsDelegate() {
    return DefaultFetcherListActionsDelegate(
      listState,
      context,
      _fetcher,
      preInitialLoad: () {
        listState.listRequestParams = listRequestParams(); //Reset to the defaults
      }
    );
  }

  void onChangedSearchField(String value) {

  }

  void onSubmittedSearchField(String value) {

  }

  void performSearch(String value) async {
    listState.listRequestParams.search = value;
    actionsDelegate.performRefresh();
  }

  Widget buildSearchBar() {
    return DefaultTextField(
      onChanged: onChangedSearchField,
      onSubmitted: onSubmittedSearchField,
      focusNode: searchTextFieldFocusNode,
      hint: searchHint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: BrandColors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              color: Colors.white,
              child: buildSearchBar(),
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: buildRefreshWidget()
              ),
            )
          ],
        ),
      ),
    );
  }

}