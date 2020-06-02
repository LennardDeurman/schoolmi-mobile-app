import 'package:schoolmi/network/models/content_object.dart';
import 'package:schoolmi/models/data/linkages/question_linked_object.dart';

class Answer extends ContentObject with QuestionLinkedObject {

  Answer (Map<String, dynamic> dictionary) : super(dictionary);

}

