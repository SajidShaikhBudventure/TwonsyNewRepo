import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketplace/helper/prefkeys.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/model/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/business_user.dart';

class Injector {
  static SharedPreferences prefs;

  static Auth auth;
  static String accessToken;

  static GoogleSignInAccount currentUser;
  static GoogleSignIn googleSignIn;

  static UserData userDataMain;

  static StreamController<String> streamController;




  static getInstance() async {
    try {
      prefs = await SharedPreferences.getInstance();


      streamController = StreamController.broadcast();

      googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      getUserData();
    } catch (e) {
      print(e);
    }
  }



  static updateAuthData(Auth auth1) async {
    await Injector.prefs
        .setString(PrefKeys.refreshToken, jsonEncode(auth1.toJson()));

    auth = auth1;
    if (userDataMain.auth != null) {
      auth = auth;
      accessToken = auth.accessToken;
    }
  }

  static updateUserData(UserData userData) async {
    await Injector.prefs
        .setString(PrefKeys.user, jsonEncode(userData.toJson()));

    userDataMain = userData;
    if (userDataMain.auth != null) {
      auth = userDataMain.auth;
      accessToken = auth.accessToken;
    }
  }

  static updateVerifyUserData(UserData userData) async {
    userData.profileStatus=1;
    await Injector.prefs
        .setString(PrefKeys.user, jsonEncode(userData.toJson()));

    userDataMain = userData;
    if (userDataMain.auth != null) {
      auth = userDataMain.auth;
      accessToken = auth.accessToken;
    }
  }
  static updateVerifyUserDataSign(UserData userData,String token) async {
    userData.profileStatus=1;
    userData.mesibo_token=token;
    await Injector.prefs
        .setString(PrefKeys.user, jsonEncode(userData.toJson()));

    userDataMain = userData;
    if (userDataMain.auth != null) {
      auth = userDataMain.auth;
      accessToken = auth.accessToken;
    }
  }

  static getUserData() {
    if (prefs.getString(PrefKeys.user) != null &&
        prefs.getString(PrefKeys.user).isNotEmpty) {
      userDataMain =
          UserData.fromJson(jsonDecode(prefs.getString(PrefKeys.user)));
      if (userDataMain.auth != null) {
        auth = userDataMain.auth;
        accessToken = auth.accessToken;
      }
    }
  }


}
