import 'package:flutter/material.dart';
import 'package:schoolmi/extensions/func_utils.dart';

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

class StaticTableViewSection {

  final int numberOfRows;
  final Function headerBuilder;
  final Function(int row) itemBuilder;

  StaticTableViewSection ({ this.numberOfRows = 1, this.headerBuilder, this.itemBuilder });

}

class TableViewBuilder {

  final Function (BuildContext context, int index, int section) itemBuilder;
  final Function (int section) sectionHeaderBuilder;
  final Function (int section) sectionFooterBuilder;
  final Function (int section) numberOfRows;
  final int sectionCount;

  int _rowCount = 0;

  int get rowCount {
    return _rowCount;
  }

  List<Section> _tableViewSections = [];

  TableViewBuilder ({this.itemBuilder, this.sectionHeaderBuilder, this.sectionFooterBuilder, this.numberOfRows, this.sectionCount = 1}) {
    buildSections();
  }

  void buildSections() {
    Section lastSection;
    for (int sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
      Section section = Section(
          sectionIndex: sectionIndex,
          hasHeader: FuncUtils.funcResult(sectionHeaderBuilder, () => sectionHeaderBuilder(sectionIndex)) != null,
          hasFooter: FuncUtils.funcResult(sectionFooterBuilder, () => sectionFooterBuilder(sectionIndex)) != null,
          startIndex: lastSection != null ? lastSection.endIndex + 1 : 0,
          numberOfRows: numberOfRows(sectionIndex));
      int numberOfTotalRows = section.rowCount(includeHeadersAndFooters: true);
      lastSection = section;
      _rowCount += numberOfTotalRows;
      _tableViewSections.add(section);
    }
  }

  Section findCurrentSection (int rowPosition) {
    for (var section in _tableViewSections) {
      if (rowPosition <= section.endIndex) {
        return section;
      }
    }
    return null;
  }

  Widget rowBuilder(BuildContext context, int position) {
    Section section = findCurrentSection(position);
    int innerIndex = position - section.startIndex;
    if (section.hasHeader && position == section.startIndex) {
      return sectionHeaderBuilder(section.sectionIndex);
    } else if (section.hasFooter && position == section.endIndex) {
      return sectionFooterBuilder(section.sectionIndex);
    } else {
      int objectIndex = innerIndex;
      if (section.hasHeader) {
        objectIndex -= 1;
      }
      return itemBuilder(context, objectIndex, section.sectionIndex);
    }
  }



}

class TableView extends StatelessWidget {

  final TableViewBuilder builder;

  TableView(this.builder);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(context: context, child: ListView.builder(
      itemCount: builder.rowCount,
      itemBuilder: (BuildContext context, int position) {
        return builder.rowBuilder(context, position);
      },
    ), removeTop: true);
  }

}

class StaticTableView  {

  static TableView withSections (List<StaticTableViewSection> tableViewSections ) {
    return TableView(
        TableViewBuilder(
          sectionCount: tableViewSections.length,
          numberOfRows: (int section) {
            return tableViewSections[section].numberOfRows;
          },
          sectionHeaderBuilder: (int section) {
            Function function = tableViewSections[section].headerBuilder;
            if (function != null) {
              return function();
            }
          },
          itemBuilder: (BuildContext context, int index, int section) {
            return tableViewSections[section].itemBuilder(index);
          }
        )
    );
  }

}