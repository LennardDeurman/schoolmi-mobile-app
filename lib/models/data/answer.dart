import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_comments.dart';
import 'package:schoolmi/models/data/extensions/object_with_votes.dart';
import 'package:schoolmi/models/data/extensions/object_with_attachments.dart';
import 'package:schoolmi/models/data/extensions/object_with_flags.dart';

class Answer extends BaseObject with ObjectWithComments, ObjectWithFlags, ObjectWithVotes, ObjectWithAttachments {

  int channelId;
  int questionId;
  String body;

  Answer (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseCommentInfo(dictionary);
    parseVotesInfo(dictionary, questionId: questionId, answerId: id);
    parseAttachments(dictionary);
    parseFlagInfo(dictionary);

    channelId = dictionary[Keys.channelId];
    questionId = dictionary[Keys.questionId];
    body = dictionary[Keys.body];
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(commentsDictionary());
    superDict.addAll(attachmentsDictionary());
    superDict.addAll(flagInfoDictionary());
    superDict.addAll(votesInfo.votesInfoDictionary());
    superDict[Keys.questionId] = questionId;
    superDict[Keys.channelId] = channelId;
    superDict[Keys.body] = body;
    return superDict;
  }
}

