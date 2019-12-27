import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:flutter/foundation.dart';
class LoginResult {

  ParsingResult profileResult;
  FirebaseUser firebaseUser;
  Channel _activeChannel;
  ParsingResult _myChannelsResult;


  LoginResult ({ @required ParsingResult myChannelsResult, @required this.profileResult, @required this.firebaseUser }) {
    if (myChannelsResult.objects.length > 0) {
      _activeChannel = myChannelsResult.objects.first;
    }
    _myChannelsResult = myChannelsResult;
  }

  List<Channel> get channels {
    return _myChannelsResult.objects;
  }

  Channel get activeChannel {
    return _activeChannel;
  }

  bool get hasActiveChannel {
    return _activeChannel != null;
  }

  set activeChannel (Channel channel) {
    if (!isAuthorizedChannel(channel)) {
      _myChannelsResult.add(channel);
    }
    _activeChannel = channel;

  }

  get myChannelsResult {
    return _myChannelsResult;
  }

  set myChannelsResult (ParsingResult parsingResult) { //A new channels result was parsed in refreshing

    //Possible cases: a channel is no longer valid, no channels exist anymore, or there is a new active channel
    //If case of a new active channel, first check whether the old one is still valid

    _myChannelsResult = parsingResult;

    if (_activeChannel != null) {
      if (isAuthorizedChannel(_activeChannel)) {
        return;
      }
    }
    if (parsingResult.objects.length > 0) {
      _activeChannel = parsingResult.objects.first;
    } else {
      _activeChannel = null;
    }
  }


  Profile get profile {
    return profileResult.object;
  }

  bool isAuthorizedChannel(Channel channel) {
    return _myChannelsResult.objects.contains(channel);
  }

  bool isActiveChannel (Channel channel) {
    if (_activeChannel != null) {
      return (_activeChannel.id == channel.id);
    }
    return false;
  }

}