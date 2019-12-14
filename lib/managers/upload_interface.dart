
abstract class UploadInterface<T> {

  T uploadObject;

  Future<T> save();

}