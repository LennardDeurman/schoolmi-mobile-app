import 'package:flutter/material.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/widgets/message_container.dart';
import 'package:schoolmi/localization/localization.dart';

/*

This class is used for streaming the active channel content. Returns the builder if a channel is currently active,
otherwise returns a loader with the corresponding information

 */


class ActiveChannelLayout {

  ActiveChannelLayout ();


  Widget build({@required Widget Function(Channel channel) builder}) {
    return StreamBuilder<DownloadStatus>(
      builder: (BuildContext context, AsyncSnapshot<DownloadStatus> loginStatusSnapshot) {
        //An event is pushed every time the loginRefreshManager changes in state (downloading, succeed, failed)
        if (UserService().loginResult != null) {
          if (UserService().hasActiveChannel) { //If an active channel is present, then directly start building content
            return builder(UserService().loginResult.activeChannel);
          } else { //A login result is present, but no active channel
            return MessageContainer(
              topWidget: CircularProgressIndicator(),
              title: Localization().getValue(Localization().addChannel),
              subtitle: Localization().getValue(Localization().addChannelDescription),
            );
          }
        }

        return MessageContainer(
          topWidget: CircularProgressIndicator(),
          title: Localization().getValue(Localization().environmentLoading),
        );

      },
      stream: UserService().loginStream, //Based on home manager downloadStatus and ScopedModelDescendant of the childManager
    );
  }

}