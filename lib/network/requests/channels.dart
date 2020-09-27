import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/routes/global.dart';

class PublicChannelsRequest extends RestRequest<Channel> {

  PublicChannelsRequest () : super (
      GlobalRoute().publicChannels,
      objectCreator: (Map<String, dynamic> map) {
        return Channel(map);
      }
  );

  @override
  Future<Channel> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<List<Channel>> postAll(List<Channel> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<Channel> postSingle(Channel objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

}

class MyChannelsRequest extends RestRequest<Channel> {

  MyChannelsRequest () : super(
      GlobalRoute().myChannels,
      objectCreator: (Map<String, dynamic> map) {
        return Channel(map);
      }
  );

  @override
  Future<Channel> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }
  
  @override
  Future delete() {
    throw UnimplementedError();
  }


}