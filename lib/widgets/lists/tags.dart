import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/widgets/lists/base/search.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/cells/tag.dart';
import 'package:schoolmi/network/models/tag.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/selection.dart';

class TagsListView extends FetcherListView<Tag> {

  final TagsManager manager;

  final SelectionManager<Tag> selectionManager;

  TagsListView (this.manager, { this.selectionManager });

  @override
  FetcherListViewState<FetcherListView<Tag>, Tag> createState() {
    return TagsListViewState();
  }

}

class TagsPickerListViewState extends TagsListViewState {

  @override
  Widget objectCellBuilder(Tag tag) {
    return TagCell(tag, onTagPressed: (Tag tag) {
      widget.selectionManager.toggle(tag);
    });
  }

  Widget buildTagsSelectionBox() {
    return ScopedModelDescendant<SelectionManager<Tag>>(
        builder: (BuildContext context, Widget widget, SelectionManager<Tag> manager) {
          return Wrap(children: manager.objects.map((value) {
            return Container(
              padding: EdgeInsets.only(right: 5.0),
              child: TagChip(
                  color: Colors.blueAccent,
                  title: value.name,
                  onDeleted: () {
                    manager.toggle(value);
                  }),
            );
          }).toList());
        }
    );
  }

  @override
  Widget buildSearchBar() {
    return Column(
      children: <Widget>[
        super.buildSearchBar(),
        buildTagsSelectionBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: widget.selectionManager,
        child: super.build(context)
    );
  }

}

class TagsListViewState extends SearchListViewState<TagsListView, Tag> {

  bool shouldShowCreate(Tag newTag) {
    return widget.manager.channel.canAddTags && !listState.fetchResult.objects.contains(newTag) && listState.listRequestParams.hasSearch;
  }

  void onNewTagPressed(Tag tag) async {
    widget.manager.uploadObject = tag;
    var objects = await widget.manager.saveUploadObjects();
    listState.appendResult(FetchResult<Tag>(objects));
  }

  void onDeleteTagPressed(Tag tag) async {
    tag.isDeleted = true;
    widget.manager.uploadObject = tag;
    var objects = await widget.manager.saveUploadObjects();
    listState.removeObjects(objects);
  }



  @override
  Widget objectCellBuilder(Tag tag) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: TagCell(tag, leading: widget.manager.pendingObjects.contains(tag) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Container() ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: Localization().getValue(Localization().delete),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            onDeleteTagPressed(tag);
          },
        )
      ],
    );
  }

  @override
  Widget buildBackground() {
    if (listState.fetchResult != null && listState.fetchResult.objects.length == 0) {
      return Container(); //Show an empty container instead of default, when no results are returned
    } else {
      return super.buildBackground();
    }
  }

  @override
  String get searchHint {
    return Localization().getValue(Localization().tagsHint);
  }

  @override
  void onSubmittedSearchField(String value) {
    performSearch(value);
  }

}