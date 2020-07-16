import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class BaseManager extends Model {

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  set isLoading (bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<T> executeAsync<T>(Future<T> future) async {
    isLoading = true;
    return future.whenComplete(() {
      isLoading = false;
    });
  }
}

class UserEventsHandler {

  Function onProfileChange;
  Function onActiveChannelChange;

  UserEventsHandler ({ this.onProfileChange, this.onActiveChannelChange });

  void registerActiveChannelListener() {
    UserService().userResult.registerActiveChannelListener(_onActiveChannelChange);
  }

  void registerMyProfileListener() {
    UserService().userResult.unregisterProfileListener(_onProfileChange);
  }

  void unregisterActiveChannelListener() {
    UserService().userResult.unregisterActiveChannelListener(_onActiveChannelChange);
  }

  void unregisterMyProfileListener() {
    UserService().userResult.unregisterActiveChannelListener(_onProfileChange);
  }

  void registerAllEventListeners() {
    registerActiveChannelListener();
    registerMyProfileListener();
  }


  void unregisterAllEventListeners() {
    unregisterActiveChannelListener();
    unregisterMyProfileListener();
  }

  void _onProfileChange() {
    if (this.onProfileChange != null)
      this.onProfileChange();
  }

  void _onActiveChannelChange() {
    if (this.onProfileChange != null)
      this.onActiveChannelChange();
  }

}

abstract class UploadInterface<T extends ParsableObject> {

  List<T> uploadObjects;

  List<T> pendingObjects = new List();

  set uploadObject (T object) {
    uploadObjects = [object];
  }

  T get uploadObject {
    if (uploadObjects.length == 0) {
      return null;
    }
    return uploadObjects.first;
  }

  Future<List<T>> saveUploadObjects() {
    throw UnimplementedError();
  }

  Future<T> saveUploadObject() {
    throw UnimplementedError();
  }

  Future<List<T>> performMultiUpload({ Future<List<T>> Function(List<T> objects) uploadFutureBuilder }) async {
    if (uploadObjects.length == 0) {
      throw new Exception("At least one upload object required for this request");
    }
    var currentUploadObjects = uploadObjects;
    pendingObjects.addAll(currentUploadObjects);
    return uploadFutureBuilder(uploadObjects).whenComplete(() {
      pendingObjects.removeWhere((value) {
        return currentUploadObjects.contains(value);
      });
    });
  }

  Future<T> performSingleUpload({ Future<T> Function(T object) uploadFutureBuilder }) async {
    if (uploadObject == null) {
      throw new Exception("You need to set a uploadObject");
    }

    var currentUploadObject = uploadObject;
    return uploadFutureBuilder(uploadObject).whenComplete(() {
      pendingObjects.removeWhere((value) {
        return value == currentUploadObject;
      });
    });
  }

}
