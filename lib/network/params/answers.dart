import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/keys.dart';
class AnswersRequestParams extends ListRequestParams {

  bool showDeletedAnswers;

  AnswersRequestParams ({
    this.showDeletedAnswers = false,
    search,
    offset = 0,
    limit = 50,
    orderType,
    firebaseUids,
    roleIds
  }) : super(
      search: search,
      offset: offset,
      limit: limit,
      orderType: orderType,
      firebaseUids: firebaseUids,
      roleIds: roleIds
  );

  Map<String, String> get queryMap {
    Map<String, String> queryMap = super.queryMap;
    queryMap[Keys().showDeletedAnswers] = queryParam(showDeletedAnswers);
    return queryMap;
  }



}