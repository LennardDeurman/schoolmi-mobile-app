
import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/extensions/enum_utils.dart';

enum QuestionsFilterMode {
  all,
  followed,
  newItems,
  updated,
  unanswered,
  flagged,
  deleted
}

class QuestionsRequestParams extends ListRequestParams {

  QuestionsFilterMode filterMode;

  QuestionsRequestParams ({
    this.filterMode,
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
    queryMap[Keys().filterMode] = queryParam(EnumUtils.indexOf(filterMode, QuestionsFilterMode.values));
    return queryMap;
  }

}