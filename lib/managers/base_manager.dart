import 'package:scoped_model/scoped_model.dart';


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