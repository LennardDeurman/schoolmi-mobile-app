import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schoolmi/managers/tags.dart';
import 'package:schoolmi/managers/selection.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/announcer.dart';
import 'package:schoolmi/network/parsers/tags.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/widgets/textfield.dart';
import 'package:schoolmi/widgets/cells/tag.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/tag.dart';
import 'package:scoped_model/scoped_model.dart';

class TagsListView extends ParserListView {

  final TagsManager manager;

  final SelectionManager<Tag> selectionManager;

  TagsListView (this.manager, { this.selectionManager }) : super(manager.parser);

  @override
  State<StatefulWidget> createState() {
    return selectionManager != null ? _TagsPickerState() : _TagsListState();
  }

}


class _TagsPickerState extends _TagsListState {

  @override
  bool shouldShowCreate(Tag newTag) {
    if (widget.manager.channel.canAddTags && widget.manager.isQueryValid()) {
      if (parsingResult != null) {
        List<Tag> tags = parsingResult.objects;
        return !(tags.where((Tag object) {
          return object.name.trim().toLowerCase() == newTag.name.trim().toLowerCase();
        }).length > 0);
      }
    }
    return false;
  }

  @override
  Widget buildListItem(BaseObject object) {
    Tag tag = object;
    return TagListItemCell(tag, onTagPressed: (Tag tag) {
      widget.selectionManager.toggle(tag);
    });
  }

  @override
  Widget buildTagsSelectionBox() {
    return ScopedModelDescendant<SelectionManager<Tag>>(
      builder: (BuildContext context, Widget widget, SelectionManager<Tag> manager) {
        return Wrap(children: manager.objects.map((value) {
          return Container(
            padding: EdgeInsets.only(right: 5.0),
            child: TagCellWithIcon(
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
  Widget build(BuildContext context) {
    return ScopedModel(
      model: widget.selectionManager,
      child: super.build(context)
    );
  }

}

class _TagsListState extends ParserListViewState<TagsListView> {

  final FocusNode _searchTextFieldFocusNode = FocusNode();

  @override
  bool get canLoadMore {
    return false;
  }

  bool shouldShowCreate(Tag newTag) {
    return widget.manager.channel.canAddTags && !parsingResult.objects.contains(newTag);
  }

  void onNewTagPressed(Tag tag) async {
    widget.manager.uploadObject = tag;
    var objects = await widget.manager.saveUploadObjects();
    setState(() {
      parsingResult.objects.addAll(objects);
    });
  }

  void onDeleteTagPressed(Tag tag) async {
    tag.isDeleted = true;
    widget.manager.uploadObject = tag;
    var objects = await widget.manager.saveUploadObjects();
    setState(() {
      parsingResult.objects.remove(objects.first);
    });

  }

  Widget buildTagsSelectionBox() {
    return Container();
  }

  @override
  Widget buildListItem(BaseObject object) {
    Tag tag = object;


    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: TagListItemCell(tag, leading: widget.manager.pendingObjects.contains(tag) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Container() ),
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
  Widget buildFooter(int section) {

    TagsParser parser = widget.parser;
    if (parser.queryInfo != null) {
      String search = parser.queryInfo.search;
      if (search != null) {

        Tag tag = Tag.create(name: search);

        if (shouldShowCreate(tag)) {
          return TagListItemCell(
              tag,
              leading: widget.manager.pendingObjects.contains(tag) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : IconButton(icon: Icon(FontAwesomeIcons.plus, color: BrandColors.lightGrey), onPressed: () {
                onNewTagPressed(tag);
              }),
          );
        }
      }
    }

    return Container();
  }

  @override
  Widget buildNoResultsBackground() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: BrandColors.blueGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.white,
            child:  Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DefaultTextField(
                      onSubmitted: (String value) {
                        TagsParser parser = widget.parser;
                        parser.queryInfo = null;
                        if (value != null) {
                          if (value.length > 0) {
                            parser.queryInfo = new QueryInfo(
                                search: value
                            );
                          }
                        }

                        refreshIndicatorKey.currentState.show();
                      },
                      focusNode: _searchTextFieldFocusNode,
                      hint: Localization().getValue(Localization().tagsHint),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: buildRefreshWidget()
            ),
          )
        ],
      ),
    );
  }


}