import 'package:schoolmi/managers/channel_details.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/upload_interface.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/network/parsers/roles.dart';
import 'package:schoolmi/network/query_info.dart';

class RolesManager extends ChannelDetailsChildManager with UploadInterface<Role> {


  ParsingResult _rolesResult;

  ParsingResult get data {
    return _rolesResult;
  }

  RolesManager (HomeManager homeManager) : super(homeManager);

  @override
  void onChannelLoad(Channel channel) {
    super.onChannelLoad(channel);
    parser = RolesParser(channel);
    _rolesResult = null;
  }

  Future download() async {
    ParsingResult parsingResult = await parser.download();
    ParserWithQueryInfo parserWithQueryInfo = parser as ParserWithQueryInfo;
    if (parserWithQueryInfo.isQueryInfoEmpty()) {
      _rolesResult = parsingResult;
    }
    return parsingResult;
  }

  Future deleteRole(Role role) async {
    int indexOf = _rolesResult.objects.indexOf(role);
    _rolesResult.objects.removeAt(indexOf);
    notifyListeners();
    role.isDeleted = true;
    uploadObject = role;
    await saveUploadObjects().catchError((e) {
      role.isDeleted = false;
      _rolesResult.objects.insert(indexOf, role);
      notifyListeners();
    });
  }

  @override
  Future<List<Role>> saveUploadObjects() {
    return executeAsync<List<Role>>(wrapUpload(performUpload(parser)));
  }

}