import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';

class ChannelSubObjectsRequest<T extends ParsableObject> extends RestRequest<T> {

  ChannelSubObjectsRequest (String path, { objectCreator }) : super(
      path,
      objectCreator: objectCreator
  );

  @override
  Future<T> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }


}