import 'dart:async';
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/routes/channel.dart';
import 'package:schoolmi/network/urls.dart';

class ChannelDetailsRequest extends Request {

  final int channelId;

  ChannelRoute route;

  ChannelDetailsRequest (this.channelId) {
    this.route = ChannelRoute(channelId: channelId);
  }

  Future<Member> join() {
    Completer<Member> completer = Completer();
    executeJsonRequest(route.join, completer, (response) {
      var jsonResponse = jsonObjectResponse(response);
      completer.complete(Member(jsonResponse));
    });
    return completer.future;
  }

  Future leave() {
    Completer completer = Completer();
    executeJsonRequest(route.leave, completer, (response) => completer.complete());
    return completer.future;
  }

  Future<String> getCode() {
    Completer<String> completer = Completer();
    executeJsonRequest(route.joinCode, completer, (response) {
      completer.complete(jsonObjectResponse(response));
    });
    return completer.future;
  }

  Future<String> resetCode() {
    Completer<String> completer = Completer();
    executeJsonRequest(route.joinCode, completer, (response) {
      completer.complete(jsonObjectResponse(response));
    }, httpMethod: HttpMethod.post);
    return completer.future;
  }
}