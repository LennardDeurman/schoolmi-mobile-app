import 'package:flutter/material.dart';
import 'package:schoolmi/managers/channels/tags.dart';
import 'package:schoolmi/managers/selection.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/lists/channels/details/tags.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/models/tag.dart';

class TagsPage extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TagsManager tagsManager;

  final SelectionManager<Tag> selectionManager;

  TagsPage ({ this.tagsManager, this.selectionManager });

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TitleLabel(
            title: Localization().getValue(Localization().tags, usePluralForm: true),
            color: Colors.white,
          ),
        ),
        floatingActionButton: this.selectionManager != null ? buildFloatingActionButton(context) : null,
        body:TagsListView(this.tagsManager, selectionManager: this.selectionManager)
    );
  }

}