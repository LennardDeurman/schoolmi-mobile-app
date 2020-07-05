import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/settings/notification_settings.dart';
import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:schoolmi/network/download_info.dart';

class NotificationSettingsRequest extends RestRequest<NotificationSettings> {

  NotificationSettingsRequest (String path) : super(
      path,
      objectCreator: (Map<String, dynamic> map) {
        return NotificationSettings(map);
      }
  );

  @override
  Future<List<NotificationSettings>> getAll({RequestParams params, DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationSettings>> postAll(List<NotificationSettings> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}
