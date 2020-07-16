import 'package:schoolmi/network/params/list.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/extensions/enum_utils.dart';

enum MembersFilterMode {
  showActive,
  showBlocked,
  showDeleted
}

class MembersRequestParams extends ListRequestParams {

  MembersFilterMode filterMode;

  MembersRequestParams ({
    this.filterMode,
    search,
    offset = 0,
    limit = 50,
    orderType
  }) : super(
      search: search,
      offset: offset,
      limit: limit,
      orderType: orderType
  );

  Map<String, String> get queryMap {
    Map<String, String> queryMap = super.queryMap;
    queryMap[Keys().filterMode] = queryParam(EnumUtils.indexOf(filterMode, MembersFilterMode.values));
    return queryMap;
  }

}
