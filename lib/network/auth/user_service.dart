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

  StreamController<LoginResult> _loginStreamController = new StreamController();

  LoginResult _loginResult;

  static final UserService _instance = UserService._internal();

  factory UserService () {
    return _instance;
  }

  UserService._internal () {
    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser firebaseUser) async {
      if (firebaseUser != null) {
        if (firebaseUser.isEmailVerified) {
          refreshStreamState(firebaseUser);
        } else {
          _sendLoginResult(null);
        }
      } else {
        if (_loginResult != null) {
          _destroyData(_loginResult);
        }
      }
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

  bool get hasActiveChannel {
    if (_loginResult != null) {
      return _loginResult.activeChannel != null;
    }
    return false;
  }

  Future<LoginResult> loadData(FirebaseUser firebaseUser, { bool forceRefresh = false }) async {

    ParsingResult profileResult = await profileParser.loadCachedData();
    if (profileResult == null || forceRefresh) {
      profileResult = ParsingResult([await createProfile()]);
    }

    ParsingResult myChannelsResult = await myChannelsParser.loadCachedData();
    if (myChannelsResult != null || forceRefresh) {
      myChannelsResult = await myChannelsParser.download();
    }

    return _sendLoginResult(LoginResult(myChannelsResult: myChannelsResult, profileResult: profileResult, firebaseUser: firebaseUser));
  }

  Future<Profile> createProfile() async {
    ParsingResult parsingResult = await profileParser.download();
    Profile profile = parsingResult.object;
    if (profile == null) {
      profile = await profileParser.uploadObject(await Profile.cachedProfile());
    }
    return profile;
  }

  Future login({ String email, String password }) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    ParsingResult profileResult =  ParsingResult([await createProfile()]);
    ParsingResult myChannelsResult = await myChannelsParser.download();
    return _sendLoginResult(LoginResult(myChannelsResult: myChannelsResult, profileResult: profileResult, firebaseUser: firebaseUser));
  }

  Future register({ String email, String password }) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    ParsingResult profileResult =  ParsingResult([await createProfile()]);
    ParsingResult myChannelsResult = await myChannelsParser.download();
    return _sendLoginResult(LoginResult(myChannelsResult: myChannelsResult, profileResult: profileResult, firebaseUser: firebaseUser));
  }

  Future sendPasswordForgotEmail({ String email }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future refreshData({ bool forceRefresh = false }) {
    return loadData(_loginResult.firebaseUser, forceRefresh: forceRefresh);
  }

  Future refreshStreamState(FirebaseUser firebaseUser) async {
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