import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/json_object_formatter.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:schoolmi/network/download_info.dart';

abstract class IRest<T> {

  Future delete();

  Future<List<T>> getAll({ RequestParams params });

  Future<T> getSingle();

  Future<T> postSingle( T objectToPost, { singleObjectFormat = true } );

  Future<List<T>> postAll(List<T> objectsToPost, { singleObjectFormat = false });

}

class RestRequest<T extends ParsableObject> extends Request with IRest<T>  {

  final String path;
  final T Function(Map<String, dynamic>) objectCreator;

  JsonObjectFormatter formatter;

  RestRequest (this.path, { this.objectCreator }) {
    formatter = JsonObjectFormatter<T>(objectCreator);
  }


  Future delete() {
    return http.delete(Urls.urlForPath(
        path: path
    ));
  }

  Future<List<T>> postAll(List<T> objectsToPost, { singleObjectFormat = false }) {
    Completer<List<T>> completer = new Completer();
    executeJsonRequest(Urls.urlForPath(
        path: this.path
    ), completer, (http.Response response) {
      List<T> responseObjects = formatter.parseObjects(jsonObjectResponse(response));
      completer.complete(responseObjects);
    }, postDictionary: this.formatter.toPostData(objectsToPost, singleObjectFormat: singleObjectFormat));
    return completer.future;
  }


  Future<T> postSingle(T objectToPost, { singleObjectFormat = true }) {
    Completer<T> completer = new Completer();
    postAll([objectToPost], singleObjectFormat: singleObjectFormat).then((List<T> objects) {
      if (objects.length > 0) {
        completer.complete(objects.first);
      } else {
        completer.complete(null);
      }
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }


  Future<T> getSingle({ DownloadStatusInfo downloadStatusListener }) {
    Completer<T> completer = Completer();
    getAll(
        downloadStatusListener: downloadStatusListener
    ).then((value) {
      if (value.length > 0) {
        completer.complete(value.first);
      } else {
        completer.complete(null);
      }
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }


  Future<List<T>> getAll({ RequestParams params, DownloadStatusInfo downloadStatusListener }) {
    Completer<List<T>> completer = new Completer();
    downloadStatusListener.downloadDidStart();
    String url = Urls.urlForPath(
        path: this.path,
        params: params
    );
    executeJsonRequest(url, completer, (http.Response response) {
      var jsonResponse = jsonObjectResponse(response);
      List<T> items = formatter.parseObjects(jsonResponse);
      completer.complete(items);
    });

    completer.future.then((_) {
      downloadStatusListener.downloadDidSucceed();
    });

    completer.future.catchError((e) {
      downloadStatusListener.downloadDidFail(e);
    });

    return completer.future;
  }

}