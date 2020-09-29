import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class PostConfig {

  List<String> skipKeys = [Keys().dateAdded, Keys().dateModified];

  Map<String, dynamic> filter(Map<String, dynamic> map) {
    map.removeWhere((key, value) {
      return skipKeys.contains(key);
    });
    return map;
  }

}

class JsonObjectFormatter<T extends ParsableObject> {

  final PostConfig postConfig = PostConfig();

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
      return postConfig.filter(objectToPost.toDictionary());
    } else {
      var dictList = [];
      for (T object in objectsToPost) {
        dictList.add(
            postConfig.filter(object.toDictionary())
        );
      }
      return dictList;
    }
  }

}