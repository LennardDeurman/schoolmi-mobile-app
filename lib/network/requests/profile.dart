import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/routes/global.dart';
import 'package:schoolmi/network/params/abstract/base.dart';

class ProfileRequest extends RestRequest<Profile> {

  ProfileRequest () : super(
      GlobalRoute().profile,
      objectCreator: (Map<String, dynamic> map) {
        return Profile(map);
      }
  );



  @override
  Future<List<Profile>> getAll({RequestParams params, downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }


}