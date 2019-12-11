import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/managers/home.dart';

class ChildManager extends BaseManager {

  HomeManager homeManager;


  ChildManager (this.homeManager) {
    loadData();
    homeManager.loginRefreshManager.downloadStatusInfo.downloadStatusStream.listen((_) { //The loginResult was changed, so re-render
      willUpdateLoginResult();
      notifyListeners();
      didUpdateLoginResult();
    });
  }

  void loadData() {}

  void willUpdateLoginResult() {
    loadData();
  }

  void didUpdateLoginResult() {}


}