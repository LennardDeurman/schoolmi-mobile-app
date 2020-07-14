import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class SelectionManager<T extends BaseObject> extends BaseManager {

  List<T> objects = new List<T>();

  void toggle(T object) {
    if (objects.contains(object)) {
      objects.remove(object);
    } else {
      objects.add(object);
    }
    notifyListeners();
  }

}