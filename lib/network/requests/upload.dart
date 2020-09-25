import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:schoolmi/network/models/attachment.dart';
import 'package:schoolmi/network/params/upload.dart';
import 'package:schoolmi/network/auth/provider.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/network/routes/global.dart';
import 'package:schoolmi/network/keys.dart';

class UploadRequest extends Request {

  Future<Upload> upload({
    @required File file,
    UploadRequestParams uploadRequestParams
  }) async {
    Completer<Upload> completer = Completer();
    Map<String, String> headers = {
      Headers.idToken: await AuthorizationProvider.getIdToken(),
      Headers.contentType: Headers.mediaTypeJson
    };

    List<int> bytes = file.readAsBytesSync();
    String fileName = file.path.split("/").last;
    Uri url = Uri.parse(Urls.urlForPath(
        path: GlobalRoute().upload,
        params: uploadRequestParams
    ));

    http.MultipartRequest multipartRequest = http.MultipartRequest(
        "POST", url
    );

    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(http.MultipartFile.fromBytes(
      Keys().file,
      bytes,
      filename: fileName,
    ));
    multipartRequest.send().then((http.StreamedResponse response) async {
      http.Response httpResponse = await http.Response.fromStream(response);
      final body = jsonObjectResponse(httpResponse);
      completer.complete(Upload(body));
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

}
