import 'dart:async';

import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/network/models/attachment.dart';
import 'package:schoolmi/network/requests/upload.dart';
import 'package:schoolmi/network/params/upload.dart';
import 'dart:io';

class FileUploadManager extends BaseManager {

  final UploadRequest uploadRequest = UploadRequest();

  final String initialUrl;

  Upload _uploadObject;

  FileUploadManager (this.initialUrl);

  String get presentingUrl {
    if (_uploadObject != null)
      return _uploadObject.uploadUrl;
    return initialUrl;
  }

  Future<Upload> upload({ File file, UploadRequestParams params }) async {
    Completer<Upload> completer = Completer();
    executeAsync(uploadRequest.upload(file: file, uploadRequestParams: params).then((Upload upload) {
      this._uploadObject = upload;
      completer.complete(upload);
    })).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }


}