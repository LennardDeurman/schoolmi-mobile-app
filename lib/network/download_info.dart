import 'dart:async';

enum DownloadStatus {
  idle,
  downloading,
  success,
  failed
}


class DownloadStatusInfo {

  DownloadStatus _downloadStatus = DownloadStatus.idle;
  StreamController<DownloadStatus> _downloadStatusController = new StreamController();
  dynamic exception;


  DownloadStatusInfo () {
    _downloadStatusController.onCancel = () {
      _downloadStatusController.close();
    };
  }

  Stream<DownloadStatus> get downloadStatusStream {
    return _downloadStatusController.stream;
  }

  DownloadStatus get downloadStatus {
    return _downloadStatus;
  }

  set downloadStatus (DownloadStatus status) {
    _downloadStatus = status;
    if (status != DownloadStatus.failed) {
      exception = null;
    }
    _downloadStatusController.sink.add(status);
  }

  //Status update functions

  void downloadDidStart() {
    downloadStatus = DownloadStatus.downloading;
  }

  void downloadDidSucceed() {
    downloadStatus = DownloadStatus.success;
  }

  void downloadDidFail(e) {
    downloadStatus = DownloadStatus.failed;
    this.exception = e;
  }

}