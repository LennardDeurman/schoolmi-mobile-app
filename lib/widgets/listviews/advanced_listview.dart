import 'package:flutter/material.dart';

class AdvancedListView extends StatelessWidget {

  final Function (BuildContext, int index, int section) itemBuilder;
  final Function (int section) headerBuilder;
  final Function (int section) footerBuilder;
  final Function (int section) numberOfRows;
  final int sectionCount;

  int _totalItemCount;

  AdvancedListView.builder({this.itemBuilder, this.headerBuilder, this.footerBuilder, this.numberOfRows, this.sectionCount = 1}) {
    _totalItemCount = _calculateTotalItemCount();

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _totalItemCount,
      itemBuilder: (BuildContext context, int position) {
        return _buildWidget(context, position);
      },
    );
  }

  Widget _buildWidget(BuildContext context, int position) {
    int previousSectionEnd = 0;
    for (int section = 0; section < this.sectionCount; section++) {
      int sectionStart = previousSectionEnd;
      int itemsCount = this.numberOfRows(section);
      int numberOfRows = itemsCount
          + ( _footerForSection(section) != null ? 1 : 0) +
          ( _headerForSection(section) != null ? 1 : 0);
      int sectionEnd = sectionStart + numberOfRows;
      previousSectionEnd = sectionEnd;
      if (position >= sectionStart && position < sectionEnd) {
        int rowIndex = position - sectionStart;
        Widget header = _headerForSection(section);
        Widget footer = _footerForSection(section);
        if (header != null && rowIndex == 0) {
          return header;
        } else if (footer != null && rowIndex == (numberOfRows - 1)) {
          return footer;
        } else {
          return itemBuilder(context, rowIndex, section);
        }

      }
    }
    return null;
  }


  Widget _headerForSection(int section) {
    if (headerBuilder != null) {
      return headerBuilder(section);
    }
    return null;
  }

  Widget _footerForSection (int section) {
    if (footerBuilder != null) {
      return footerBuilder(section);
    }
    return null;
  }

  int _calculateTotalItemCount() {
    int totalItemCount = 0;
    for (int section = 0; section < sectionCount; section++) {

      totalItemCount += numberOfRows(section)
          + ( _footerForSection(section) != null ? 1 : 0) +
          ( _headerForSection(section) != null ? 1 : 0);


    }



    return totalItemCount;
  }

}