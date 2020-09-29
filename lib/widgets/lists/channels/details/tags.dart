import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/widgets/extensions/backgrounds.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/lists/base/search.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/cells/tag.dart';
import 'package:schoolmi/network/models/tag.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/routes/channel.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/channels/tags.dart';
import 'package:schoolmi/managers/selection.dart';

class TagsListView extends FetcherListView<Tag> {

  final TagsManager tagsManager;

  final SelectionManager<Tag> selectionManager;

  TagsListView (this.tagsManager, { this.selectionManager });

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

class TagsTableViewProvider extends FetcherTableViewProvider<Tag> {

  TagsManager manager;
  Function(Tag) onNewTagPressed;

  TagsTableViewProvider (this.manager, ListState<Tag> listState, { Function builder, this.onNewTagPressed }) : super(listState, builder: builder);

  bool shouldShowCreate(Tag newTag) {
    bool isAuthorized = (manager.channel.canAddTags || manager.channel.isCurrentUserAdmin);
    bool doesNotContain = !listState.fetchResult.objects.contains(newTag);
    return isAuthorized && doesNotContain;
  }

  @override
  Widget sectionFooterBuilder(int section) {
    if (listState.listRequestParams.hasSearch) {
      Tag tag = Tag.create(name: listState.listRequestParams.search);

      if (shouldShowCreate(tag)) {
        return TagCell(
          tag,
          leading: manager.pendingObjects.contains(tag) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : IconButton(icon: Icon(FontAwesomeIcons.plus, color: BrandColors.lightGrey), onPressed: () {
            onNewTagPressed(tag);
          }),
        );
      }
    }

    return Container();
  }

}

class TagsListViewState extends SearchListViewState<TagsListView, Tag> {


  void onNewTagPressed(Tag tag) async {
    widget.tagsManager.uploadObject = tag;
    var objects = await widget.tagsManager.saveUploadObjects();
    listState.appendResult(FetchResult<Tag>(objects));
  }

  void onDeleteTagPressed(Tag tag) async {
    tag.isDeleted = true;
    widget.tagsManager.uploadObject = tag;
    var objects = await widget.tagsManager.saveUploadObjects();
    listState.removeObjects(objects);
  }
  
  

  FetcherTableViewProvider tableViewProvider() {
    return TagsTableViewProvider(widget.tagsManager, listState, builder: (object) {
      return objectCellBuilder(object);
    }, onNewTagPressed: onNewTagPressed);
  }
  
  @override
  Fetcher<Tag> fetcher() {
    return Fetcher<Tag>(
        RestRequest(
            ChannelRoute(
                channelId: widget.tagsManager.channel.id
            ).tags,
            objectCreator: (json) {
              return Tag(json);
            }
        )
    );
  }


  @override
  Widget objectCellBuilder(Tag tag) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: TagCell(tag, leading: widget.tagsManager.pendingObjects.contains(tag) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Container() ),
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
      if (!listState.listRequestParams.hasSearch) {
        return MessageContainer(
          topWidget: SvgPicture.asset(AssetPaths.tag, width: 80),
          title: Localization().getValue(Localization().noTagsYet),
          subtitle:  Localization().getValue(Localization().createNewTagHint),
        );
      }
      //Show an empty container instead of default, when no results are returned
    } else {
      return super.buildBackground();
    }

    return Container();
  }

  @override
  String get searchHint {
    return Localization().getValue(Localization().tagsHint);
  }

  @override
  void onChangedSearchField(String value) {
    performSearch(value);
  }



}