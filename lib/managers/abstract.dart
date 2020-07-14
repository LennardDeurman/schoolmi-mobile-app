import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/network/auth/user_service.dart';

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

abstract class UploadInterface<T> {

  T uploadObject;

  Future<T> save();

}
