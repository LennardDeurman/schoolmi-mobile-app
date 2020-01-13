import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/pages/profile.dart';

class Presenter {

  final BuildContext context;

  Presenter (this.context);

  void showQuestion(Question question) {

  }

  void showTags(Channel channel) {

  }

  void showNotifications(Channel channel) {

  }

  void showMembers(Channel channel) {

  }


  void showInvite(Channel channel) {

  }

  void showChannelEdit({ Channel channel }) {

  }

  void showMyProfile(ProfileManager manager) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return ProfilePage(manager);
      }
    ));
  }
}