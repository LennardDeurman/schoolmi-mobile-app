import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/models/data/profile.dart';

class QuestionViewer extends Profile {

  DateTime viewTime;

  QuestionViewer (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    viewTime = Dates.parse(dictionary[Keys.viewTime]);
  }

}