import 'package:flutter/material.dart';

class Section {

  bool hasHeader;
  bool hasFooter;
  int numberOfRows;
  int startIndex;
  int endIndex;
  int sectionIndex;

  Section ({@required this.hasHeader, @required this.sectionIndex, @required this.hasFooter, @required this.startIndex, @required this.numberOfRows}) {
    int totalRowCount = rowCount(includeHeadersAndFooters: true);
    if (totalRowCount == 0) {
      endIndex = startIndex;
    } else {
      endIndex = startIndex + totalRowCount - 1;
    }
  }

  int rowCount({ bool includeHeadersAndFooters = false }) {
    if (includeHeadersAndFooters) {
      int total = numberOfRows;
      if (hasHeader)
        total += 1;
      if (hasFooter)
        total += 1;
      return total;
    }
    return numberOfRows;
  }

}

class ListViewSection {

  final int numberOfRows;
  final Function headerBuilder;
  final Function(int row) itemBuilder;

  ListViewSection ({ this.numberOfRows = 1, this.headerBuilder, this.itemBuilder });

}



class AdvancedListView extends StatelessWidget {

  final Function (BuildContext, int index, int section) itemBuilder;
  final Function (int section) headerBuilder;
  final Function (int section) footerBuilder;
  final Function (int section) numberOfRows;
  final int sectionCount;

  List<Section> _sections = [];
  int _totalItemCount = 0;

  AdvancedListView.builder({this.itemBuilder, this.headerBuilder, this.footerBuilder, this.numberOfRows, this.sectionCount = 1}) {
    _buildSections();
  }

  static AdvancedListView withSections({ List<ListViewSection> listViewSections }) {
    return AdvancedListView.builder(
      sectionCount: listViewSections.length,
      numberOfRows: (int section) {
        return listViewSections[section].numberOfRows;
      },
      headerBuilder: (int section) {
        Function function = listViewSections[section].headerBuilder;
        if (function != null) {
          return function();
        }
      },
      itemBuilder: (BuildContext context, int index, int section) {
        return listViewSections[section].itemBuilder(index);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(context: context, child: ListView.builder(
      itemCount: _totalItemCount,
      itemBuilder: (BuildContext context, int position) {
        return _buildWidget(context, position);
      },
    ), removeTop: true);
  }

  Section _findCurrentSection (int position) {
    for (var section in _sections) {
      if (position <= section.endIndex) {
        return section;
      }
    }
    return null;
  }




  Widget _buildWidget(BuildContext context, int position) {
    Section section = _findCurrentSection(position);
    int innerIndex = position - section.startIndex;
    if (section.hasHeader && position == section.startIndex) {
      return headerBuilder(section.sectionIndex);
    } else if (section.hasFooter && position == section.endIndex) {
      return footerBuilder(section.sectionIndex);
    } else {
      int objectIndex = innerIndex;
      if (section.hasHeader) {
        objectIndex -= 1;
      }
      return itemBuilder(context, objectIndex, section.sectionIndex);
    }
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

  void _buildSections() {
    Section lastSection;
    for (int sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
      Section section = Section(
          sectionIndex: sectionIndex,
          hasHeader: _headerForSection(sectionIndex) != null,
          hasFooter: _footerForSection(sectionIndex) != null,
          startIndex: lastSection != null ? lastSection.endIndex + 1 : 0,
          numberOfRows: numberOfRows(sectionIndex));
      int numberOfTotalRows = section.rowCount(includeHeadersAndFooters: true);
      lastSection = section;
      _totalItemCount += numberOfTotalRows;
      _sections.add(section);
    }

  }

}