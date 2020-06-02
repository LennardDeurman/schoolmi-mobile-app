import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/parsing_result.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:flutter/foundation.dart';
import 'package:schoolmi/network/cache_manager.dart';

class LoginResult {

  ParsingResult profileResult;
  FirebaseUser firebaseUser;
  Channel _activeChannel;
  ParsingResult _myChannelsResult;


  StreamController<Channel> _channelChangeStreamController = new StreamController<Channel>.broadcast();

  Stream<Channel> get onChannelChange {
    return _channelChangeStreamController.stream;
  }


  LoginResult ({ @required ParsingResult myChannelsResult, @required this.profileResult, @required this.firebaseUser }) {
    if (myChannelsResult.objects.length > 0) {
      _activeChannel = myChannelsResult.objects.first;
    }
    _myChannelsResult = myChannelsResult;

    _channelChangeStreamController.onCancel = () {
      _channelChangeStreamController.close();
    };
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

    sortChannels();
    if (_channelChangeStreamController != null) {
      _channelChangeStreamController.sink.add(_activeChannel);
    }
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
        Channel updatedChannelInfo = _myChannelsResult.objects.where((BaseObject baseObject) {
          return baseObject.id == _activeChannel.id;
        }).first;
        _activeChannel.parse(updatedChannelInfo.dictionary);
        //Reparse new info, like is_admin, members count etc
        sortChannels();
        return;
      }
    }
    if (parsingResult.objects.length > 0) {
      activeChannel = parsingResult.objects.first;
    } else {
      activeChannel = null;
    }



  }

  void sortChannels() {
    _myChannelsResult.objects.removeWhere((channel) {
      return _activeChannel.id == channel.id;
    });
    _myChannelsResult.objects.insert(0, _activeChannel);

    CacheManager.save(CacheManager.myChannels, _myChannelsResult.objects);
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