import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/extensions/future_utils.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/cache_protocol.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/profile.dart';
import 'package:schoolmi/network/requests/channels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserResult {

  CombinedResult<Channel> _myChannelsResult;
  CombinedResult<Profile> _myProfileResult;

  Channel _activeChannel;

  final FirebaseUser firebaseUser;


  UserResult ({ CombinedResult<Channel> myChannelsResult, CombinedResult<Profile> myProfileResult, this.firebaseUser }) {
    _activeChannel = myChannelsResult.result.objects.first;
    _myChannelsResult = myChannelsResult;
    _myProfileResult = myProfileResult;
  }
  
  FetchResult<Channel> get myChannelsResult {
    return _myChannelsResult.result;
  }
  
  FetchResult<Profile> get myProfileResult {
    return _myProfileResult.result;
  }
  
  
  Channel get activeChannel {
    return _activeChannel;
  }

  set activeChannel (Channel channel) {
    if (!isAuthorizedChannel(channel)) {
      _myChannelsResult.result.insertNew(channel);
    }
    _activeChannel = channel;
  }

  bool isActiveChannel (Channel channel) {
    return _activeChannel == channel;
  }

  bool isAuthorizedChannel (Channel channel) {
    return _myChannelsResult.result.objects.contains(channel);
  }

  Future refreshMyChannels() {
    return UserService().loadMyChannels().then((result) {
      this._myChannelsResult = result;
    });
  }

  Future refreshMyProfile() {
    return UserService().loadMyProfile(firebaseUser).then((result) {
      this._myProfileResult = result;
    });
  }




}


class UserService {

  final Fetcher<Profile> profileFetcher = Fetcher<Profile>(ProfileRequest());
  final Fetcher<Channel> myChannelsFetcher = Fetcher<Channel>(MyChannelsRequest());

  final MyChannelsCacheProtocol myChannelsCacheProtocol = MyChannelsCacheProtocol();
  final ProfileCacheProtocol profileCacheProtocol = ProfileCacheProtocol();

  StreamController<UserResult> _userResultStreamController = StreamController<UserResult>.broadcast();

  UserResult _userResult;

  static final UserService _instance = UserService._internal();

  factory UserService () {
    return _instance;
  }

  UserService._internal () {


    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser firebaseUser) async {
      if (firebaseUser != null) {
        if (firebaseUser.isEmailVerified) {
          _sendResult(await loadData(firebaseUser));
          return;
        }
      } else {
        if (_userResult != null) {
          _destroyData();
        }
      }
      _sendResult(null);
    });

    _userResultStreamController.onCancel = () {
      _userResultStreamController.close();
    };


  }

  Stream get userResultStream {
    return _userResultStreamController.stream;
  }

  UserResult get userResult {
    return _userResult;
  }

  Future<CombinedResult<Channel>> loadMyChannels() async {
    return CombinedResult<Channel>(
      onlineResult: await FutureUtils.safeLoad(myChannelsFetcher.download(
          cacheProtocol: myChannelsCacheProtocol
      )),
      offlineResult: await myChannelsCacheProtocol.load()
    );
  }

  Future<CombinedResult<Profile>> loadMyProfile(FirebaseUser firebaseUser) async {
    return CombinedResult<Profile>(
      onlineResult: await FutureUtils.safeLoad(createProfile(firebaseUser).then((e) {
        return FetchResult([e]);
      })),
      offlineResult: await profileCacheProtocol.load()
    );
  }

  Future<UserResult> loadData(FirebaseUser firebaseUser) async {

    try {

      CombinedResult<Channel> myChannelsResult = await loadMyChannels();
      CombinedResult<Profile> myProfileResult = await loadMyProfile(firebaseUser);
      //Validate the profile result
      if (myProfileResult.result == null) {
        await FirebaseAuth.instance.signOut();
        return null;
      }

      return _sendResult(UserResult(
          myChannelsResult: myChannelsResult,
          myProfileResult: myProfileResult,
          firebaseUser: firebaseUser
      ));
    } catch (e) {
      print("Something went wrong in login loadData();" + e.toString());
      print("Forcing relogin");
      return _sendResult(null);
    }

  }

  Future<Profile> createProfile(FirebaseUser firebaseUser) async {
    FetchResult<Profile> fetchResult = await profileFetcher.download(
      cacheProtocol: profileCacheProtocol
    );
    Profile profile = fetchResult.object;
    if (profile == null) {
      var cachedProfile = await Profile.cachedProfile();
      cachedProfile.email = firebaseUser.email;
      try {
        profile = await profileFetcher.restRequest.postSingle(cachedProfile);
      } catch (e) {
        print("profile could not created!!");
        print(e);
      }
    }
    return profile;
  }

  Future login({ String email, String password }) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    FetchResult<Profile> profileResult =  FetchResult<Profile>([await createProfile(firebaseUser)]);
    if (profileResult.object == null) {
      throw new InvalidOperationException("No profile could be created");
    }
    FetchResult<Channel> myChannelsResult = await myChannelsFetcher.download(
      cacheProtocol: myChannelsCacheProtocol
    );
    return _sendResult(
        UserResult(
            myChannelsResult: CombinedResult<Channel>(
              onlineResult: myChannelsResult
            ),
            myProfileResult: CombinedResult<Profile>(
              onlineResult: profileResult
            ),
            firebaseUser: firebaseUser
        )
    );
  }

  Future register({ String email, String password }) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    FetchResult<Profile> profileResult =  FetchResult<Profile>([await createProfile(firebaseUser)]);
    if (profileResult.object == null) {
      throw new InvalidOperationException("No profile could be created");
    }
    FetchResult myChannelsResult = await myChannelsFetcher.download(
      cacheProtocol: myChannelsCacheProtocol
    );
    return _sendResult(
        UserResult(
            myChannelsResult: CombinedResult<Channel>(
                onlineResult: myChannelsResult
            ),
            myProfileResult: CombinedResult<Profile>(
                onlineResult: profileResult
            ),
            firebaseUser: firebaseUser
        )
    );
  }

  Future sendPasswordForgotEmail({ String email }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future refreshStream(FirebaseUser firebaseUser) async {
    _sendResult(await loadData(firebaseUser));
  }

  UserResult _sendResult(UserResult userResult) {
    _userResult = userResult;
    _userResultStreamController.sink.add(userResult);
    return _userResult;
  }


  void _deleteAllCachedData()  {
    SharedPreferences.getInstance().then((register) {
      register.clear();
    });
  }

  void _destroyData() {
    _deleteAllCachedData();
    _sendResult(null);
  }


}