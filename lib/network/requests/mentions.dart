import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/requests/abstract/channel_subobjects.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/urls.dart';


class MentionsRequest extends ChannelSubObjectsRequest<ParsableObject> {

  MentionsRequest (String path) : super(
      path
  );

  @override
  Future<List<ParsableObject>> getAll({RequestParams params, downloadStatusListener}) {
    Completer<List<ParsableObject>> completer = new Completer();
    downloadStatusListener.downloadDidStart();
    String url = Urls.urlForPath(
        path: this.path,
        params: params
    );
    executeJsonRequest(url, completer, (http.Response response) {
      var jsonObject = jsonObjectResponse(response);
      var membersJsonMaps = jsonObject[Keys().members];
      var rolesJsonMaps = jsonObject[Keys().roles];

      List<ParsableObject> items = [];

      for (Map<String, dynamic> jsonMap in rolesJsonMaps) {
        items.add(Role(jsonMap));
      }

      for (Map<String, dynamic> jsonMap in membersJsonMaps) {
        items.add(Member(jsonMap));
      }



      completer.complete(items);
    });

    completer.future.then((_) {
      downloadStatusListener.downloadDidSucceed();
    });

    completer.future.catchError((e) {
      downloadStatusListener.downloadDidFail(e);
    });

    return completer.future;
  }

  @override
  Future<List<ParsableObject>> postAll(List objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

}