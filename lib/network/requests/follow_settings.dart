import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/settings/event_preferences.dart';
import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:schoolmi/network/download_info.dart';


class FollowSettingsRequest<T extends EventPreferences> extends RestRequest<T> {

  FollowSettingsRequest (String path, { T Function(Map<String, dynamic>) objectCreator }) : super(
      path,
      objectCreator: objectCreator
  );

  @override
  Future<List<T>> getAll({RequestParams params, DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<T>> postAll(List<T> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}