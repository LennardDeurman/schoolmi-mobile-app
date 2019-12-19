import 'package:flutter/material.dart';
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

class TagsListView extends ParserListView {

  TagsListView (TagsParser parser) : super(parser);

  @override
  State<StatefulWidget> createState() {
    return _TagsListViewState();
  }

}

class _TagsListViewState extends ParserListViewState<TagsListView> {

  final FocusNode _searchTextFieldFocusNode = FocusNode();

  @override
  bool get canLoadMore {
    return false;
  }

  bool shouldShowSearch(Tag newTag) {
    return false;
  }

  void onNewTagPressed(Tag tag) {
    tagsManager.saveUploadObject(tag).then(() {
      setState(() { });
    });
  }

  Widget buildTagsSelectionBox() {
    return Container();
  }

  @override
  Widget buildListItem(BaseObject object) {
    Tag tag = object;
    return TagListItemCell(tag);
  }

  @override
  Widget buildFooter(int section) {

    TagsParser parser = widget.parser;
    String search = parser.queryInfo.search;
    if (search != null) {
      Tag tag = Tag.fromSearch(search);
      if (shouldShowSearch(tag)) {
        return TagListItemCell(
            tag,
            leading: tagsManager.pendingObjects.contains(tag) ? CircularProgressIndicator(strokeWidth: 2) : Icon(FontAwesomeIcons.plus, color: BrandColors.lightGrey),
            onTagPressed: onNewTagPressed
        );
      }
    }
    return Container();
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
              color: Colors.white,
              child:  Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DefaultTextField(
                        onChanged: (String value) async {
                          TagsParser parser = widget.parser;
                          parser.queryInfo = new QueryInfo(
                              search: value
                          );
                          await performRefresh();
                        },
                        focusNode: _searchTextFieldFocusNode,
                        hint: Localization().getValue(Localization().tagsHint),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                color: BrandColors.blueGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Announcer(title: Localization().getValue(Localization().results)),
                    buildTagsSelectionBox(),
                  ],
                )
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