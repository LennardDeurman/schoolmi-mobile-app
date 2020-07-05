import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/extensions/enum_utils.dart';

enum ListOrder {
  updated,
  newest,
  points
}

class ListRequestParams extends RequestParams {

  final String search;
  final ListOrder orderType;
  final int limit;
  final int offset;

  final List<int> roleIds;
  final List<String> firebaseUids;

  ListRequestParams ({
    this.search,
    this.offset = 0,
    this.limit = 50,
    this.orderType,
    this.firebaseUids,
    this.roleIds
  });

  bool get hasSearch {
    if (search != null) {
      return search.isNotEmpty;
    }
    return false;
  }

  Map<String, String> get queryMap {
    return {
      Keys().search: queryParam(search),
      Keys().orderType: queryParam(EnumUtils.indexOf(orderType, ListOrder.values)),
      Keys().limit: queryParam(limit),
      Keys().roles: listQueryParam(roleIds),
      Keys().users: listQueryParam(firebaseUids),
      Keys().offset: queryParam(offset)
    };
  }



}