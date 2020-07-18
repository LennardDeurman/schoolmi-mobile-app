import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/pages/profile.dart';
import 'package:schoolmi/pages/channels/details/members/overview.dart';
import 'package:schoolmi/pages/channels/details/tags.dart';
import 'package:schoolmi/pages/channels/edit.dart';
import 'package:schoolmi/pages/channels/suggestions.dart';
import 'package:schoolmi/managers/channels/tags.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/network/models/channel.dart';

class Presenter {

  final BuildContext context;

  Presenter (this.context);

  void showTags(TagsManager tagsManager) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return TagsPage(
            tagsManager: tagsManager
          );
        }
    ));
  }


  void showMembers(MembersManager membersManager) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return MembersPage(membersManager);
        }
    ));
  }

  void showNewChannel({ Function(Channel) onChannelEdit, Future Function(Channel) joinChannelFutureBuilder  }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return SuggestedChannelsPage(
            onChannelEdit: onChannelEdit,
            joinChannelFutureBuilder: joinChannelFutureBuilder,
          );
        }
    ));
  }

  void showNotifications(Channel channel) {
    //TODO: !!
  }

  void showInvite(Channel channel) {
    //TODO: !!
  }


  void showChannelEdit({ Channel channel, Function onChannelEdit }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return ChannelEditPage(
            channel: channel,
            onChannelEdited: onChannelEdit,
          );
        }
    ));
  }


  void showMyProfile(ProfileManager manager) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfilePage(manager);
        }
    ));
  }
}