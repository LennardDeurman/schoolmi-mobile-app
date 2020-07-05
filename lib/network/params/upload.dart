import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/params/abstract/base.dart';
import 'dart:io';

class UploadRequestParams extends RequestParams {

  final int width;
  final int height;
  final String mode;
  final bool makeMiniImage;
  final File file;

  UploadRequestParams ({
    this.width,
    this.height,
    this.mode = "thumbnail",
    this.makeMiniImage = false,
    this.file
  });

  Map<String, String> get queryMap {
    return {
      Keys().mode: queryParam(mode),
      Keys().width: queryParam(width),
      Keys().height: queryParam(height),
      Keys().includeMini: queryParam(makeMiniImage)
    };
  }

}