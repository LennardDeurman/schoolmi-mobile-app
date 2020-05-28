import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/constants/keys.dart';

class ObjectWithVotes  {

  VotesInfo votesInfo;

  void parseVotesInfo(Map<String, dynamic> dictionary, { int questionId, int answerId, int commentId }) {
    votesInfo = VotesInfo();
    votesInfo.questionId = questionId;
    votesInfo.answerId = answerId;
    votesInfo.commentId = commentId;
    votesInfo.parse(dictionary);
  }

}

class VoteState {
  static const int negative = -1;
  static const int neutral = 0;
  static const int positive = 1;
}

class VotesInfo extends ParsableObject {

  int votesCount = 0;
  int vote = 0;

  int questionId;
  int commentId;
  int answerId;

  int _myVoteState;

  VotesInfo ({ this.questionId, this.answerId, this.commentId });

  void _clearCurrentVoteState() {
    if (_myVoteState == VoteState.negative) {
      vote += VoteState.positive;
    } else if (_myVoteState == VoteState.positive) {
      vote += VoteState.negative;
    }
  }

  set myVoteState (int value) {
    _clearCurrentVoteState();

    vote += value;

    if (_myVoteState == null || _myVoteState == VoteState.neutral) {
      votesCount += 1;
    }

    _myVoteState = value;
  }

  int get myVoteState {
    return _myVoteState;
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    vote = ParsableObject.parseIntOrZero(dictionary[Keys().vote]);
    votesCount = ParsableObject.parseIntOrZero(dictionary[Keys().votesCount]);
    _myVoteState = ParsableObject.parseIntOrZero(dictionary[Keys().myVote]);
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().vote: _myVoteState
    };
  }

  /*
  The votesInfoDictionary provide global info to be included in the parent, while the toDictionary() object is meant to
  be sent to the server
  */

  Map<String, dynamic> votesInfoDictionary() {
    return {
      Keys().votesCount: votesCount,
      Keys().vote: vote
    };
  }
}