import 'dart:async';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/cache_protocol.dart';


class Fetcher<T extends ParsableObject>  {

  final RestRequest<T> restRequest;

  final bool singleMode;

  final DownloadStatusInfo downloadStatusInfo = new DownloadStatusInfo();

  bool get isLoading {
    return downloadStatusInfo.downloadStatus == DownloadStatus.downloading;
  }

  Fetcher ( this.restRequest, { this.singleMode = false } );


  Future<FetchResult<T>> downloadAll(Future<List<T>> downloadFuture, Completer<FetchResult<T>> completer) {
    downloadFuture.then((value) {
      completer.complete(FetchResult<T>(value));
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<FetchResult<T>> downloadSingle(Future<T> downloadFuture, Completer<FetchResult<T>> completer) {

    downloadFuture.then((value) {
      completer.complete(FetchResult<T>([value]));
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  Future<FetchResult<T>> download( { ListRequestParams params } ) {
    Completer<FetchResult<T>> completer = new Completer();
    if (this.singleMode) {
      return downloadSingle(restRequest.getSingle(downloadStatusListener: downloadStatusInfo), completer);
    } else {
      return downloadAll(restRequest.getAll(params: params, downloadStatusListener: downloadStatusInfo), completer);
    }

  }


}

