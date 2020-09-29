import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/extensions/future_utils.dart';
import 'package:schoolmi/network/fetcher.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/cache_protocol.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/requests/profile.dart';
import 'package:schoolmi/network/requests/channels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserResult {

  CombinedResult<Channel> _myChannelsResult;
  CombinedResult<Profile> _myProfileResult;

  ValueNotifier<Channel> _activeChannelNotifier;
  ValueNotifier<Profile> _profileNotifier;

  final FirebaseUser firebaseUser;


  UserResult ({ CombinedResult<Channel> myChannelsResult, CombinedResult<Profile> myProfileResult, this.firebaseUser }) {
    if (myChannelsResult.result != null && myChannelsResult.result.objects.length > 0) {
      _activeChannelNotifier = ValueNotifier<Channel>(myChannelsResult.result.objects.first);
    } else {
      _activeChannelNotifier = ValueNotifier<Channel>(null);
    }

    if (myProfileResult.result != null) {
      _profileNotifier = ValueNotifier<Profile>(myProfileResult.result.object);
    } else {
      _profileNotifier = ValueNotifier<Profile>(null);
    }

    _myChannelsResult = myChannelsResult;
    _myProfileResult = myProfileResult;
  }
  
  FetchResult<Channel> get myChannelsResult {
    return _myChannelsResult.result;
  }
  
  FetchResult<Profile> get myProfileResult {
    return _myProfileResult.result;
  }

  Profile get myProfile {
    return _profileNotifier.value;
  }
  
  Channel get activeChannel {
    return _activeChannelNotifier.value;
  }

  set activeChannel (Channel channel) {
    if (!isAuthorizedChannel(channel)) {
      _myChannelsResult.result.insertNew(channel);
    }
    _activeChannelNotifier.value = channel;
  }

  bool isActiveChannel (Channel channel) {
    return activeChannel == channel;
  }

  bool isAuthorizedChannel (Channel channel) {
    return _myChannelsResult.result.objects.contains(channel);
  }

  Future refreshMyChannels() {
    return UserService().loadMyChannels().then((result) {
      this._myChannelsResult = result;
      if (activeChannel != null && !isAuthorizedChannel(activeChannel)) {
        if (this._myChannelsResult.result.objects.length > 0) {
          _activeChannelNotifier.value = this._myChannelsResult.result.objects.first;
        } else {
          _activeChannelNotifier.value = null;
        }
      }
    });
  }

  Future refreshMyProfile() {
    return UserService().loadMyProfile(firebaseUser).then((result) {
      this._myProfileResult = result;
      _profileNotifier.value = _myProfileResult.result.object;
    });
  }

  Future refreshAll() {
    return Future.wait([
      refreshMyProfile(),
      refreshMyChannels()
    ]);
  }

  Future saveMyProfile (Profile profile) {
    return ProfileRequest().postSingle(
      profile,
      singleObjectFormat: true
    ).then((newProfile) {
      this._myProfileResult.onlineResult = FetchResult([newProfile]);
      this._profileNotifier.value = newProfile;
    });
  }

  void registerProfileListener(Function listener){
    this._profileNotifier.addListener(listener);
  }

  void unregisterProfileListener(Function listener) {
    this._profileNotifier.removeListener(listener);
  }

  void registerActiveChannelListener(Function listener) {
    this._activeChannelNotifier.addListener(listener);
  }

  void unregisterActiveChannelListener(Function listener) {
    this._activeChannelNotifier.removeListener(listener);
  }



}


class UserService {

  final Fetcher<Profile> profileFetcher = Fetcher<Profile>(ProfileRequest(), singleMode: true);
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

    _userResultStreamController.onCancel = () {
      _userResultStreamController.close();
    };

    profileFetcher.restRequest.formatter.postConfig.skipKeys.add(Keys().colorIndex);

  }

  void initializeAuthListener() { //Not to be called in unit tests
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
  }

  Stream get userResultStream {
    return _userResultStreamController.stream;
  }

  UserResult get userResult {
    return _userResult;
  }

  Future<CombinedResult<Channel>> loadMyChannels() async {


    var onlineResult = await FutureUtils.safeLoad(myChannelsFetcher.download());
    if (onlineResult != null) {
      myChannelsCacheProtocol.save(
          onlineResult.objects
      );
    }


    var offlineResult = await myChannelsCacheProtocol.load();

    return CombinedResult<Channel>(
      onlineResult: onlineResult,
      offlineResult: offlineResult
    );
  }

  Future<CombinedResult<Profile>> loadMyProfile(FirebaseUser firebaseUser) async {
    var profileLoadFuture = createProfile(firebaseUser).then((e) {
      return FetchResult([e]);
    });
    var onlineResult = await FutureUtils.safeLoad(profileLoadFuture);
    if (onlineResult != null) {
      profileCacheProtocol.save(onlineResult.objects);
    }

    return CombinedResult<Profile>(
      onlineResult: onlineResult,
      offlineResult: await profileCacheProtocol.load()
    );
  }

  Future<UserResult> loadData(FirebaseUser firebaseUser) async {

    try {

      CombinedResult<Channel> myChannelsResult = await loadMyChannels();
      CombinedResult<Profile> myProfileResult = await loadMyProfile(firebaseUser);
      //Validate the profile result
      return _sendResult(UserResult(
          myChannelsResult: myChannelsResult,
          myProfileResult: myProfileResult,
          firebaseUser: firebaseUser
      ));

    } catch (e) {
      print("Something went wrong in login loadData();" + e.toString());
      print("Forcing relogin");
      return null;
    }

  }

  Future<Profile> createProfile(FirebaseUser firebaseUser) async {
    FetchResult<Profile> fetchResult = await profileFetcher.download();
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
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    var firebaseUser = result.user;
    FetchResult<Profile> profileResult =  FetchResult<Profile>([await createProfile(firebaseUser)]);

    FetchResult<Channel> myChannelsResult = await myChannelsFetcher.download();
    myChannelsCacheProtocol.save(myChannelsResult.objects);

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

    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    var firebaseUser = result.user;

    FetchResult<Profile> profileResult =  FetchResult<Profile>([await createProfile(firebaseUser)]);

    FetchResult myChannelsResult = await myChannelsFetcher.download();
    myChannelsCacheProtocol.save(myChannelsResult.objects);

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