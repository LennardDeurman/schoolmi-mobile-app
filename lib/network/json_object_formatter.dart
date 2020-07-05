import 'package:schoolmi/network/models/abstract/base.dart';
class JsonObjectFormatter<T extends ParsableObject> {

  final T Function(Map<String, dynamic>) objectCreator;

  JsonObjectFormatter(this.objectCreator);

  List<T> parseObjects(dynamic jsonResponse) {
    List<T> items = [];
    if (jsonResponse is List) {
      items = parseAsList(jsonResponse);
    } else if (jsonResponse is Map<String, dynamic>) {
      items.add(parseObject(jsonResponse));
    }
    return items;
  }

  List<T> parseAsList(List jsonResponse) {
    List<T> items = [];
    for (Map<String, dynamic> jsonMap in jsonResponse) {
      var newObject = this.objectCreator(jsonMap);
      items.add(newObject);
    }
    return items;
  }

  T parseObject(Map<String, dynamic> response) {
    return this.objectCreator(response);
  }

  toPostData(List<T> objectsToPost, { bool singleObjectFormat = false}) {
    if (singleObjectFormat) {
      T objectToPost = objectsToPost.length > 0 ? objectsToPost.first : null;
      return objectToPost.toDictionary();
    } else {
      var dictList = [];
      for (T object in objectsToPost) {
        dictList.add(
            object.toDictionary()
        );
      }
      return dictList;
    }
  }

}