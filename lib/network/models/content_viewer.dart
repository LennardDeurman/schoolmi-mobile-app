import 'package:schoolmi/network/models/abstract/content_child_object.dart';

class ContentViewer extends ContentChildObject {

  ContentViewer (Map<String, dynamic> dictionary) : super(dictionary);

  DateTime get viewTime {
    return this.dateModified;
  }
}