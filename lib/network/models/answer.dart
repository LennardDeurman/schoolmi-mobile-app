import 'package:schoolmi/network/models/abstract/content_object.dart';
import 'package:schoolmi/network/models/linkages/question_linked_object.dart';

class Answer extends ContentObject with QuestionLinkedObject {

  Answer (Map<String, dynamic> dictionary) : super(dictionary);

}

