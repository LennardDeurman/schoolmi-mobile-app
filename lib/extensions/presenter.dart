import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/dialogs/intro.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/pages/profile.dart';
import 'package:schoolmi/pages/channels/details/members/overview.dart';
import 'package:schoolmi/pages/channels/details/tags.dart';
import 'package:schoolmi/pages/channels/edit.dart';
import 'package:schoolmi/pages/channels/suggestions.dart';
import 'package:schoolmi/widgets/dialogs/connection_error.dart';
import 'package:schoolmi/managers/channels/tags.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/managers/home.dart';
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

  void showConnectionError(HomeManager homeManager, GlobalKey<ScaffoldState> scaffoldKey) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ScopedModel(
              model: homeManager,
              child: ScopedModelDescendant<HomeManager>(
                builder: (BuildContext context, Widget widget, HomeManager model)
                {
                  return ConnectionErrorDialog(
                    homeManager,
                    scaffoldKey: scaffoldKey,
                    presenter: this,
                  );
                },
              )
          );
        });
  }

  void showChannelsIntro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IntroDialog();
      }
    );
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