import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/extensions/object_with_tags.dart';
import 'package:schoolmi/models/data/extensions/object_with_flags.dart';
import 'package:schoolmi/models/data/extensions/object_with_votes.dart';
import 'package:schoolmi/models/data/extensions/object_with_attachments.dart';
import 'package:schoolmi/models/data/extensions/object_with_viewcount.dart';

class Question extends BaseObject with ObjectWithFlags, ObjectWithViewCount, ObjectWithVotes, ObjectWithAttachments, ObjectWithTags {

  int answerId;
  int channelId;
  int answerCount;
  String title;
  String body;

  Question (Map<String, dynamic> dictionary) : super(dictionary);

  bool get hasCheckedAnswer {
    return answerId != null;
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseAttachments(dictionary);
    parseVotesInfo(dictionary, questionId: id);
    parseFlagInfo(dictionary);
    parseTags(dictionary);

    answerId = dictionary[Keys.answerId];
    channelId = dictionary[Keys.channelId];
    answerCount = dictionary[Keys.answerCount] ?? 0;
    title = dictionary[Keys.title];
    body = dictionary[Keys.body];

  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(attachmentsDictionary());
    superDict.addAll(votesInfo.votesInfoDictionary());
    superDict.addAll(flagInfoDictionary());
    superDict.addAll(tagsDictionary());
    superDict[Keys.title] = title;
    superDict[Keys.body] = body;
    superDict[Keys.answerCount] = answerCount;
    superDict[Keys.answerId] = answerId;
    superDict[Keys.channelId] = channelId;
    return superDict;
  }
}
