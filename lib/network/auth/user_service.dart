import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/network/auth/login_result.dart';
import 'package:schoolmi/network/parsers/profile.dart';
import 'package:schoolmi/network/parsers/channels.dart';
import 'package:schoolmi/network/cache_manager.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'dart:async';


class UserService {

  final ProfileParser profileParser = ProfileParser();
  final ChannelsParser myChannelsParser = ChannelsParser();

  StreamController<LoginResult> _loginStreamController = StreamController();

  LoginResult _loginResult;

  static final UserService _instance = UserService._internal();

  factory UserService () {
    return _instance;
  }

  UserService._internal () {
    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser firebaseUser) async {
      if (firebaseUser != null) {
        if (firebaseUser.isEmailVerified) {
          _sendLoginResult(await loadData(firebaseUser));
          return;
        }
      } else {
        if (_loginResult != null) {
          _destroyData(_loginResult);
        }
      }
      _sendLoginResult(null);
    });

    _loginStreamController.onCancel = () {
      _loginStreamController.close();
    };


  }

  Stream get loginStream {
    return _loginStreamController.stream;
  }

  LoginResult get loginResult {
    return _loginResult;
  }

  Future<LoginResult> loadData(FirebaseUser firebaseUser, { bool forceRefresh = false }) async {

    ParsingResult profileResult = await profileParser.loadCachedData();
    if (profileResult == null || forceRefresh) {
      profileResult = ParsingResult([await createProfile(firebaseUser)]);
    }

    ParsingResult myChannelsResult = await myChannelsParser.loadCachedData();
    if (myChannelsResult == null || forceRefresh) {
      myChannelsResult = await myChannelsParser.download();
    }

    return _sendLoginResult(LoginResult(myChannelsResult: myChannelsResult, profileResult: profileResult, firebaseUser: firebaseUser));
  }

  Future<Profile> createProfile(FirebaseUser firebaseUser) async {
    ParsingResult parsingResult = await profileParser.download();
    Profile profile = parsingResult.object;
    if (profile == null) {
      var cachedProfile = await Profile.cachedProfile();
      cachedProfile.email = firebaseUser.email;
      profile = await profileParser.uploadObject(cachedProfile);
    }
    return profile;
  }

  Future login({ String email, String password }) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    ParsingResult profileResult =  ParsingResult([await createProfile(firebaseUser)]);
    ParsingResult myChannelsResult = await myChannelsParser.download();
    return _sendLoginResult(LoginResult(myChannelsResult: myChannelsResult, profileResult: profileResult, firebaseUser: firebaseUser));
  }

  Future register({ String email, String password }) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    ParsingResult profileResult =  ParsingResult([await createProfile(firebaseUser)]);
    ParsingResult myChannelsResult = await myChannelsParser.download();
    return _sendLoginResult(LoginResult(myChannelsResult: myChannelsResult, profileResult: profileResult, firebaseUser: firebaseUser));
  }

  Future sendPasswordForgotEmail({ String email }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future refreshStream(FirebaseUser firebaseUser) async {
    _sendLoginResult(await loadData(firebaseUser));
  }


  LoginResult _sendLoginResult(LoginResult loginResult) {
    _loginResult = loginResult;
    _loginStreamController.sink.add(loginResult);
    return _loginResult;
  }

  void _destroyData(LoginResult loginResult) {
    CacheManager.deleteAllData();
    _sendLoginResult(null);
  }


}