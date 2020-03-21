import 'package:schoolmi/models/data/extensions/object_with_votes.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:scoped_model/scoped_model.dart';

class VotesManager extends Model {


  void bindEvents(Model parentModel) {  //When an event is called within this model, the parent notify is called
    addListener(() {
      parentModel.notifyListeners();
    });
  }

  void updateVoteInfo(ObjectWithVotes objectWithVotes, int newVoteState, { Function onError }) {
    int oldVoteState = objectWithVotes.votesInfo.myVoteState;
    objectWithVotes.votesInfo.myVoteState = newVoteState;
    notifyListeners();
    Api.updateVotes(
        votesInfo: objectWithVotes.votesInfo,
        channelId: UserService().loginResult.activeChannel.id
    ).catchError((e) {
      objectWithVotes.votesInfo.myVoteState = oldVoteState;
      notifyListeners();
      if (onError != null) {
        onError();
      }
    });

  }

}