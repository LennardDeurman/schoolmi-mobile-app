import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/managers/home.dart';

class ChildManager extends BaseManager {

  HomeManager homeManager;


  ChildManager (this.homeManager) {
    initialize();
    loadData();
  }

  void loadData() {}

  void initialize() {}

}