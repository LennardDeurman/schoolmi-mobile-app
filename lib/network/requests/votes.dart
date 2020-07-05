import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/extensions/object_with_votes.dart';

class VotesRequest extends RestRequest<VotesInfo> {

  VotesRequest (String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return null;
      }
  );

  @override
  Future<List<VotesInfo>> postAll(List<VotesInfo> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<List<VotesInfo>> getAll({ params, downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<VotesInfo> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}