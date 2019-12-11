
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:flutter/foundation.dart';

//Used for posting to the server
class Duplicate {

  Question question;
  Question duplicateOfQuestion;
  bool deleted = false;
  String uid;

  Duplicate ({ @required this.question, @required this.duplicateOfQuestion, this.deleted = false, this.uid });

}

class DuplicateQuestion extends Question {


  List<Profile> reporters = [];

  DuplicateQuestion (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    reporters = [];
    if (dictionary[Keys.reporters] != null) {
      List reportersJson = dictionary[Keys.reporters];
      for (Map item in reportersJson) {
        reporters.add(Profile(item as Map<String, dynamic>));
      }
    }
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict[Keys.reporters] = reporters.map((Profile profile) {
      return profile.toDictionary();
    }).toList();
    return superDict;
  }


}