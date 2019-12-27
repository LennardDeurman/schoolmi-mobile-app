import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:schoolmi/models/base_object.dart';

abstract class UploadInterface<T extends BaseObject> {

  List<T> uploadObjects;

  List<T> pendingObjects = new List();

  NetworkParser parser;

  set uploadObject (T object) {
    uploadObjects = [object];
  }

  T get uploadObject {
    if (uploadObjects.length == 0) {
      return null;
    }
    return uploadObjects.first;
  }


  Future<List<BaseObject>> performUpload(NetworkParser parser) async {
    if (uploadObjects.length == 0) {
      throw new InvalidOperationException("At least one upload object required for this request");
    }
    var currentUploadObjects = uploadObjects;
    pendingObjects.addAll(currentUploadObjects);
    return parser.uploadObjects(uploadObjects).whenComplete(() {
      pendingObjects.removeWhere((value) {
        return currentUploadObjects.contains(value);
      });
    });
  }

  Future<List<T>> saveUploadObjects();





}