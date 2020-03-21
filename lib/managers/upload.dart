
import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/models/data/upload.dart';
import 'dart:io';

class UploadManager extends BaseManager {


  String dataUrl;

  Upload uploadedFile;

  String get presentingUrl {
    if (uploadedFile != null) {
      return uploadedFile.url;
    }
    return dataUrl;
  }

  Future upload(File file) async {
    return executeAsync(Api.uploadFile(file: file).then((Upload upload) {
      uploadedFile = upload;
    }));
  }

}