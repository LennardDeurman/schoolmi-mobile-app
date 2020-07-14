class FuncUtils {

  static dynamic funcResult(Function toCheck, Function toFire) {
    if (toCheck != null) {
      return toFire();
    }
    return null;
  }

}