import 'package:flutter/material.dart';
import 'package:schoolmi/models/data/extensions/object_with_votes.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/title.dart';

class Votes extends StatelessWidget {

  final VotesInfo votesInfo;
  final Function(int newVoteState) onVoteStateChanged;


  Votes(this.votesInfo, { this.onVoteStateChanged });

  void _changeVoteState(int clickedState) {
    int newVoteState = 0;
    if (clickedState == votesInfo.myVoteState) {
      newVoteState = 0;
    } else {
      newVoteState = clickedState;
    }
    votesInfo.myVoteState = newVoteState;
    onVoteStateChanged(newVoteState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          HighlightedIcon(
            iconData: Icons.keyboard_arrow_up,
            selected: votesInfo.myVoteState == VoteState.positive,
            onPressed: () {
              _changeVoteState(VoteState.positive);
            },
          ),
          TitleLabel(
              title: votesInfo.vote.toString()
          ),
          HighlightedIcon(
            iconData: Icons.keyboard_arrow_down,
            selected: votesInfo.myVoteState == VoteState.negative,
            onPressed: () {
              _changeVoteState(VoteState.negative);
            },
          ),
        ],
      ),
    );
  }

}