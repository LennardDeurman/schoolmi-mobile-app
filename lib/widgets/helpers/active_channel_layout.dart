import 'package:flutter/material.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/widgets/message_container.dart';
import 'package:schoolmi/localization/localization.dart';

/*

This class is used for streaming the active channel content. Returns the builder if a channel is currently active,
otherwise returns a loader with the corresponding information

 */


class ActiveChannelLayout {

  HomeManager homeManager;

  ActiveChannelLayout (this.homeManager);


  Widget build({@required Widget Function(Channel channel) builder}) {
    if (UserService().loginResult.hasActiveChannel) {
      return builder(UserService().loginResult.activeChannel);
    } else if (homeManager.isLoading) {
      return MessageContainer(
        topWidget: CircularProgressIndicator(),
        title: Localization().getValue(Localization().environmentLoading),
      );
    } else {
      return MessageContainer(
        topWidget: CircularProgressIndicator(),
        title: Localization().getValue(Localization().addChannel),
        subtitle: Localization().getValue(Localization().addChannelDescription),
      );
    }
  }

}