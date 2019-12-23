import 'package:flutter/material.dart';
import 'package:schoolmi/managers/selection.dart';
import 'package:schoolmi/managers/tags.dart';
import 'package:schoolmi/models/data/tag.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/tags.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/localization/localization.dart';

class TagsPage extends StatefulWidget {

  final TagsManager tagsManager;

  final SelectionManager<Tag> selectionManager;

  TagsPage (this.tagsManager, { this.selectionManager });


  @override
  State<StatefulWidget> createState() {
    return _TagsPageState();
  }

}


class _TagsPageState extends State<TagsPage> {


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget buildFloatingActionButton() {
    return FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: widget.tagsManager,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: TitleLabel(
                title: Localization().getValue(Localization().tags, usePluralForm: true),
                color: Colors.white,
              ),
            ),
            floatingActionButton: buildFloatingActionButton(),
            body: TagsListView(widget.tagsManager, selectionManager: widget.selectionManager)
        ));
  }


}


