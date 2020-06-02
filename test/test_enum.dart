import 'package:flutter_test/flutter_test.dart';

enum FilterMode {
  showAll,
  showDeleted,
  showNone
}

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


void main() {

  test("Enum to int", () {
    int index = EnumUtils.indexOf(FilterMode.showDeleted, FilterMode.values);
    expect(index, 1);
  });

  test("Enum from int", () {

    var filterMode = FilterMode.values[0];
    expect(filterMode, FilterMode.showAll);

  });

}