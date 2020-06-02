class EnumUtils {

  static int indexOf(value, List enumOptions) {
    for (int i = 0; i < enumOptions.length; i++) {
      var aValue = enumOptions[i];
      if (aValue == value) {
        return i;
      }
    }
    return -1;
  }

}
