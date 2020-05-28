
class Option {
  final String name;
  final Object value;

  Option (this.name, this.value);
}

class OptionsBox {


  String name;

  int selectedIndex = 0;

  List<Option> _possibleOptions = [];



  void addOption(Option option) {
    _possibleOptions.firstWhere((Option aOption) {
      return aOption.name == option.name;
    }, orElse: () {
      _possibleOptions.add(option);
      return null;
    });
  }

  void removeOption(int value) {
    _possibleOptions.removeWhere((Option option) {
      return option.value == value;
    });
  }

  String stringAtIndex (int index) {
    return _possibleOptions[index].name;
  }

  Option get value {
    return this._possibleOptions[selectedIndex];
  }

  int get optionsCount {
    return this._possibleOptions.length;
  }

  OptionsBox.fromMap(Map<String, int> map) {
    map.Keys().forEach((String key) {
      addOption(Option(key, map[key]));
    });
  }

}