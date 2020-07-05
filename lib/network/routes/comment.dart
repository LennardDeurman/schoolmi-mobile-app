import 'package:schoolmi/network/routes/extensions.dart';
class CommentRoute extends ChannelChildObjectRoute {

  final int commentId;

  CommentRoute ({
    this.commentId
  });

  String get baseRoute {
    return "channels/$channelId/comments/$commentId";
  }



}