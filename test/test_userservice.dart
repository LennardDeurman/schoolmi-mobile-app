import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schoolmi/network/auth/provider.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/requests/dummy_token.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/cache_protocol.dart';
import 'package:schoolmi/network/requests/profile.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() {


  Localization localization = Localization();
  initializeDateFormatting(localization.locale);

  test("Dummy user", () async {
    final auth = MockFirebaseAuth();
    final result = await auth.signInWithEmailAndPassword(email: "lennarddeurman@live.nl", password: "");
    final user = result.user;
    print(user.displayName);
    print(user.email);
  });

  test("Set dummy id token", () async {
    var idToken = await DummyTokenRequest().getIdToken();
    AuthorizationProvider.dummyToken = idToken;
    var retrievedToken = await AuthorizationProvider.getIdToken();
    print(retrievedToken);
    print(idToken);
  });

  test("Load channels", () async {
    SharedPreferences.setMockInitialValues({});
    AuthorizationProvider.dummyToken = await DummyTokenRequest().getIdToken();
    var result = await UserService().loadMyChannels();
    print(result.onlineResult);
    print(result.offlineResult);
  });

  test("Fetch profile", () async {
    SharedPreferences.setMockInitialValues({});
    AuthorizationProvider.dummyToken = await DummyTokenRequest().getIdToken();
    final Fetcher<Profile> profileFetcher = Fetcher<Profile>(ProfileRequest(), singleMode: true);
    final ProfileCacheProtocol profileCacheProtocol = ProfileCacheProtocol();
    FetchResult<Profile> fetchResult = await profileFetcher.download(
        cacheProtocol: profileCacheProtocol
    );
    print(fetchResult.object.toDictionary());
  });


  test("Load profile", () async {
    SharedPreferences.setMockInitialValues({});
    AuthorizationProvider.dummyToken = await DummyTokenRequest().getIdToken();
    final auth = MockFirebaseAuth();
    final result = await auth.signInWithEmailAndPassword(email: "lennarddeurman@live.nl", password: "");
    final firebaseUser = result.user;
    var profileResult = await UserService().loadMyProfile(firebaseUser);
    print(profileResult.offlineResult);
    print(profileResult.onlineResult);
  });

  test("Load all data", () {

  });

}