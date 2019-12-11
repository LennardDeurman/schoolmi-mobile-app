import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/download_info.dart';

class LoginRefreshManager {

  final DownloadStatusInfo downloadStatusInfo = new DownloadStatusInfo();

  bool get isLoading {
    return downloadStatusInfo.downloadStatus == DownloadStatus.downloading;
  }

  Future refreshData({ bool refreshProfile = true, bool refreshMyChannels = true }) async {
    try {
      downloadStatusInfo.downloadDidStart();
      List<Future> futures = [];
      if (refreshProfile) {
        futures.add(UserService().refreshProfile());
      }
      if (refreshMyChannels) {
        futures.add(UserService().refreshMyChannels());
      }
      await Future.value(futures).then((_) {
        downloadStatusInfo.downloadDidSucceed();
      });
    } catch (e) {
      downloadStatusInfo.downloadDidFail(e);
      throw e;
    }
  }

}