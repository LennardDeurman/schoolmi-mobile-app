import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/pages/add_channels.dart';
import 'package:schoolmi/pages/edit_channel.dart';
import 'package:schoolmi/pages/members.dart';
import 'package:schoolmi/pages/profile.dart';
import 'package:schoolmi/pages/tags.dart';
import 'package:schoolmi/pages/view_question.dart';

class Presenter {

  final BuildContext context;

  Presenter (this.context);

  void showQuestion(HomeManager homeManager, Question question) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return ViewQuestionPage(question, homeManager: homeManager);
        }
    ));
  }

  void showTags(HomeManager homeManager) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return TagsPage(homeManager.channelDetailsManager.tagsManager);
        }
    ));
  }

  void showNotifications(Channel channel) {

  }

  void showMembers(MembersManager membersManager) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return MembersPage(membersManager);
        }
    ));
  }


  void showInvite(Channel channel) {

  }

  void showNewChannel(HomeManager homeManager) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return AddChannelsPage(homeManager);
      }
    ));
  }

  void showChannelEdit(HomeManager homeManager, { Channel channel }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return ChannelEditPage(homeManager, channel: channel);
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