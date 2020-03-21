import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/textfield.dart';

abstract class SearchListViewState<T extends ParserListView> extends ParserListViewState<T> {

  final FocusNode searchTextFieldFocusNode = FocusNode();

  String get searchHint {
    return Localization().getValue(Localization().search);
  }

  void onChangedSearchField(String value) {

  }

  void onSubmittedSearchField(String value) {

  }

  void performSearch(String value) async {
    ParserWithQueryInfo parser = widget.parser as ParserWithQueryInfo;
    parser.queryInfo = new QueryInfo(
        search: value
    );
    await performRefresh();
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