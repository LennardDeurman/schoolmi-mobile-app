import 'package:flutter/material.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/managers/channels.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/cells/add_channel.dart';
import 'package:schoolmi/widgets/cells/public_channel.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';

class AddChannelsListView extends ParserListView {


  final ChannelsManager manager;
  final Function onSearchPressed;
  final Function onAddChannelPressed;

  AddChannelsListView (this.manager, { this.onSearchPressed, this.onAddChannelPressed }) : super(manager.publicChannelsParser);

  @override
  State<StatefulWidget> createState() {
    return _AddChannelsListViewState();
  }

}

class _AddChannelsListViewState extends ParserListViewState<AddChannelsListView> {

  @override
  bool get canLoadMore {
    return false;
  }

  @override
  int get sectionCount {
    return 2;
  }

  @override
  int numberOfRows(int section) {
    if (section == 1) {
      return parsingResult.objects.length;
    }
    return 1;
  }

  @override
  Widget buildHeader(int section) {
    if (section == 0) {
      return Container(
        padding: EdgeInsets.all(15),
        child: RegularLabel(
          title: Localization().getValue(Localization().createChannelTitle),
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (section == 1) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularLabel(
                    title: Localization().getValue(Localization().publicChannels),
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  RegularLabel(
                    title: Localization().getValue(Localization().publicChannelsDetail),
                  )
                ],
              ),
            ),
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            fillColor: BrandColors.blue,
            padding: EdgeInsets.all(4),
            child: Icon(Icons.search, color: Colors.white),
            onPressed: widget.onSearchPressed,
          )
        ],
      );
    }
    return super.buildHeader(section);
  }

  @override
  Widget buildItem(BuildContext context, int index, int section) {
    if (section == 0) {
      return AddChannelCell(
        title: Localization().getValue(Localization().createNewChannel),
        subtitle: Localization().getValue(Localization().createNewChannelDetail),
        onPressed: widget.onAddChannelPressed,
      );
    } else if (section == 1) {
      return buildListItem(parsingResult.objects[index]);
    }

    return super.buildItem(context, index, section);
  }


  @override
  Widget buildListItem(BaseObject object) {
    Channel channel = object;
    return PublicChannelCell(
      channel: channel,
      onPressedJoin: (Channel channel) {
        int indexOf = parsingResult.objects.indexOf(channel);
        parsingResult.objects.removeAt(indexOf);
        widget.manager.join(channel).catchError((e) {
          parsingResult.objects.insert(indexOf, channel);
          showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
        });
      },
    );
  }




}