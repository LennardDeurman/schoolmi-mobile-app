import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/content_flag.dart';

class FlagsRequest extends RestRequest<ContentFlag> {

  FlagsRequest ( String path ) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return ContentFlag(map);
      }
  );

  @override
  Future<ContentFlag> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

}
