
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/content_viewer.dart';

class ViewersRequest extends RestRequest<ContentViewer> {

  ViewersRequest ( String path ) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return ContentViewer(map);
      }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<ContentViewer> postSingle(ContentViewer objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ContentViewer>> postAll(List<ContentViewer> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<ContentViewer> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

}
