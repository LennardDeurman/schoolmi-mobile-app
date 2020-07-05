import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/comment.dart';

class CommentsRequest extends RestRequest<Comment> {

  CommentsRequest (String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return Comment(map);
      }
  );

  @override
  Future<Comment> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> postAll(List<Comment> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}