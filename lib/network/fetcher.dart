import 'dart:async';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/cache_protocol.dart';


class Fetcher<T extends ParsableObject>  {

  final RestRequest<T> restRequest;

  final DownloadStatusInfo downloadStatusInfo = new DownloadStatusInfo();

  bool get isLoading {
    return downloadStatusInfo.downloadStatus == DownloadStatus.downloading;
  }

  Fetcher ( this.restRequest );

  Future<FetchResult<T>> download( { ListRequestParams params, CacheProtocol cacheProtocol } ) {
    Completer<FetchResult<T>> completer = new Completer();
    restRequest.getAll(params: params, downloadStatusListener: downloadStatusInfo).then((objects) {
      var result = FetchResult<T>(objects);
      if (cacheProtocol != null) {
        cacheProtocol.save(objects);
      }
      completer.complete(result);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }


}

