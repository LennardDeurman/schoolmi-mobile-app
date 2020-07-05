import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/content_version.dart';

class VersionsRequest extends RestRequest<ContentVersion> {

  VersionsRequest (String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return ContentVersion(map);
      }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<ContentVersion> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<ContentVersion> postSingle(objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ContentVersion>> postAll(List objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

}