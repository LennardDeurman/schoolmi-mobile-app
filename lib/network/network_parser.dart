import 'package:schoolmi/models/base_object.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/api.dart';
import 'dart:convert';
import 'dart:async';



abstract class NetworkParser {

  final DownloadStatusInfo downloadStatusInfo = new DownloadStatusInfo();

  NetworkParser ();

  String get downloadUrl;

  String get uploadUrl;

  BaseObject updateObjectWithResponse(BaseObject uploadedObject, http.Response response) {
    Map rootObject = json.decode(response.body)[Keys.object];
    int newId = rootObject[Keys.lastRowId];
    uploadedObject.id = newId;
    return uploadedObject;
  }

  List<BaseObject> objectsFromPostResponse(List<BaseObject> uploadedObjects, http.Response response) {
    BaseObject baseObject = uploadedObjects.first;
    return [updateObjectWithResponse(baseObject, response)];
  }

  List<BaseObject> objectsFromResponse(http.Response response) {
    Map<String, dynamic> dictionary = json.decode(response.body);
    return ParsableObject.parseObjectsList(dictionary, Keys.object);
  }

  Map<String, dynamic> makeMultiObjectsDictionary(String key, List<BaseObject> baseObjects) {
    Map<String, dynamic> map = {
      key: baseObjects.map((BaseObject baseObject) {
        return baseObject.toDictionary();
      }).toList()
    };
    return map;
  }


  Map<String, dynamic> toPostDictionary(List<BaseObject> uploadObjects) {
    if (uploadObjects.length > 1) {
      throw new UnimplementedError("This endpoint doesn't support posting multi objects");
    } else {
      BaseObject baseObject = uploadObjects.first;
      return baseObject.toDictionary();
    }
  }

  Future<ParsingResult> loadCachedData() async {
    throw new UnimplementedError("This method is not implemented for this parser");
  }


  Future<ParsingResult> download() async {
    List<BaseObject> objects = await Api.downloadObjects(parser: this);
    return ParsingResult(objects);
  }

  Future<BaseObject> uploadObject(BaseObject uploadObject) {
    return Api.uploadObject(parser: this, uploadObject: uploadObject);
  }

  Future<List<BaseObject>> uploadObjects(List<BaseObject> uploadObjects) {
    return Api.uploadObjects(parser: this, uploadObjects: uploadObjects);
  }


}


