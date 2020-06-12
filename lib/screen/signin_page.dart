import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/model/forgot_password.dart';
import 'package:marketplace/model/signin.dart';
import 'package:marketplace/model/social_login.dart';
import 'package:marketplace/screen/create_profile.dart';
import '../model/business_user.dart';
import 'home_page.dart';
import 'dart:io' show Platform;



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgotEmail = TextEditingController();

  bool isLoading = false;
  GoogleSignInAccount _currentUser;

  String helpForgotEmailStr = "";
  bool helpForgotEmail = false;

  bool helpEmail = false;
  bool helpPassword = false;

  String helpEmailStr = "";
  String helpPasswordStr = "";
  bool signInBtnShow = true;

  String firstNameStr;
  String lastNameStr;
  String emailStr;
  String socialIdStr;
  String socialProviderStr;

  bool emailIsWrite = false;
  bool passwordIsWrite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleSignOut();
    googleSignIn();
    keyboardShow();
  }

  Future<void> _handleSignOut() async {
    setState(() {
      Injector.googleSignIn.disconnect();
    });
  }

  googleSignIn() {
    Injector.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      if (mounted) {
        setState(() {
          _currentUser = account;
          isLoading = false;
          checkUserLogin();
        });
      }
    });
    Injector.googleSignIn.signInSilently();

  }

  checkUserLogin() {
    if (_currentUser != null) {
      print(_currentUser.displayName);
      List<String> user = _currentUser.displayName.split(" ");

      setState(() {
        firstNameStr = user[0].toString();
        lastNameStr = user[1].toString();
        emailStr = _currentUser.email;
        socialIdStr = _currentUser.id;
        socialProviderStr = "google";
      });
      socialLoginApi();
    }
  }

  keyboardShow() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        if (signInBtnShow == true) {
          setState(() {
            signInBtnShow = false;
          });
        } else {
          setState(() {
            signInBtnShow = true;

          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: InkResponse(
            child: Column(
              children: <Widget>[
                SignInLabel(),
                textFiledEmail(),
                helpTextEmail(),
                textFiledPassword(),
                helpTextPassword(),
                forgotPassword(),
              ],
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
        bottomNavigationBar: loginButton(),
      ),
    );
  }

  SignInLabel() {
    return Container(
      margin: EdgeInsets.only(right: 0, left: 0, top: Utils.getDeviceHeight(context)/31),
      child: Text(
        "Sign-in to your seller account",
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorRes.fontGrey, fontSize: Utils.getDeviceHeight(context)/32, fontFamily: FontRes.nunito),
      ),
    );
  }

  forgotPassword() {
    return Container(
      height: Utils.getDeviceHeight(context)/17,
    alignment: Alignment.topRight,
      padding: EdgeInsets.only(right: Utils.getDeviceWidth(context)/20),
      margin: EdgeInsets.only(left: 0, right: 0, top: Utils.getDeviceHeight(context)/50),
      child: InkResponse(
        child: Text(
          StringRes.forgotPassword,
          style: TextStyle(color: ColorRes.black, fontSize: Utils.getDeviceWidth(context) / 22, fontFamily: FontRes.nunito),
          textAlign: TextAlign.right,
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return customDialog(StringRes.enterEmail);
              });
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
      height: Utils.getDeviceHeight(context)/13,
      width: Utils.getDeviceWidth(context),
      color: ColorRes.black,
      child: MaterialButton(
        child: Text(
          StringRes.signIn,
          style: TextStyle(color: ColorRes.white, fontSize: Utils.getDeviceHeight(context)/42, fontFamily: FontRes.nunito),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            validateForm();
          });
        },
      ),
    );
  }

  textFiledEmail() {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/23, right: Utils.getDeviceWidth(context)/23, top: Utils.getDeviceHeight(context)/30),
      child: Theme(
        data: ThemeData(primaryColor: ColorRes.black),
        child: TextFormField(
          cursorColor: ColorRes.black,
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: StringRes.email,
            hintStyle: TextStyle(color: ColorRes.fontGrey, fontFamily: FontRes.nunito),
          ),
          style: TextStyle(fontSize: Utils.getDeviceHeight(context)/55, color: ColorRes.black),
        ),
      ),
    );
  }

  textFiledPassword() {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/23, right: Utils.getDeviceWidth(context)/23, top: Utils.getDeviceWidth(context)/30),
      child: Theme(
        data: ThemeData(primaryColor: ColorRes.black),
        child: TextFormField(
          cursorColor: ColorRes.black,
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            hintText: StringRes.password,
            hintStyle: TextStyle(color: ColorRes.fontGrey, fontFamily: FontRes.nunito),
          ),
          style: TextStyle(fontSize: Utils.getDeviceHeight(context)/55, color: ColorRes.black),
        ),
      ),
    );
  }

  helpTextEmail() {
    return Visibility(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/23, top: 3),
        child: Text(helpEmailStr,
            style: TextStyle(color: ColorRes.red, fontSize: Utils.getDeviceHeight(context)/60, fontFamily: FontRes.nunito)),
      ),
      visible: helpEmail,
    );
  }

  helpTextPassword() {
    return Visibility(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/23, top: 3),
        child: Text(helpPasswordStr,
            style: TextStyle(color: ColorRes.red, fontSize: Utils.getDeviceHeight(context)/60, fontFamily: FontRes.nunito)),
      ),
      visible: helpPassword,
    );
  }

  validateForm() async {
    emailValidationLogin();
    passwordValidationLogin();

    if (emailIsWrite == true && passwordIsWrite == true) {
      signInApi();
    }
  }

  forgotEmailValidation() {
    Pattern pattern = StringRes.emailValString;
    RegExp regex = new RegExp(pattern);
    if (forgotEmail.text.isEmpty) {
      setState(() {
        Utils.showToast(StringRes.requiredFiled);
      });
      return;
    } else if (!regex.hasMatch(forgotEmail.text)) {
      setState(() {
        Utils.showToast(StringRes.emailFiledVal);
      });
      return;
    } else {
      setState(() {
        forgotPasswordApi();
      });
    }
  }

  emailValidationLogin() {
    Pattern pattern = StringRes.emailValString;
    RegExp regex = new RegExp(pattern);
    if (email.text.isEmpty) {
      setState(() {
        helpEmailStr = StringRes.requiredFiled;
        helpEmail = true;
        emailIsWrite = false;
      });
      return;
    } else if (!regex.hasMatch(email.text)) {
      setState(() {
        helpEmailStr = StringRes.emailFiledVal;
        helpEmail = true;
        emailIsWrite = false;
      });
      return;
    } else {
      setState(() {
        helpEmail = false;
        emailIsWrite = true;
      });
    }
  }

  passwordValidationLogin() {
    if (password.text.isEmpty) {
      setState(() {
        helpPasswordStr = StringRes.requiredFiled;
        helpPassword = true;
        passwordIsWrite = false;
      });
      return;
    } else {
      setState(() {
        helpPassword = false;
        passwordIsWrite = true;
      });
    }
  }

  customDialog(String categoryName) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: Utils.getDeviceHeight(context)/4.2,
        width: Utils.getDeviceWidth(context)*0.9,
        child: Padding(
          padding: EdgeInsets.only(top: Utils.getDeviceHeight(context)/80, bottom: Utils.getDeviceHeight(context)/80, left: Utils.getDeviceWidth(context)/25, right: Utils.getDeviceWidth(context)/25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment(0,0),
                height: Utils.getDeviceHeight(context)/22,
                width: Utils.getDeviceWidth(context)*0.9,
                margin: EdgeInsets.only(top:Utils.getDeviceHeight(context)/140, left:0, right:0, bottom: Utils.getDeviceHeight(context)/60),
                child: Text(
                  categoryName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: Utils.getDeviceHeight(context)/45),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Container(
                height: Utils.getDeviceHeight(context)/20,
                margin: EdgeInsets.only(top:0, left:0, right:0, bottom: Utils.getDeviceHeight(context)/60),
                child: Theme(
                  data: ThemeData(primaryColor: ColorRes.black),
                  child: TextFormField(
                    cursorColor: ColorRes.black,
                    controller: forgotEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:EdgeInsets.only(left: Utils.getDeviceHeight(context)/100, right: Utils.getDeviceHeight(context)/100, top: Utils.getDeviceHeight(context)/40)
                    ),
                  ),
                  ),

              ),
              Container(
                margin: EdgeInsets.only(top: 0, right: 0, left: 0,bottom: 0),
                height: Utils.getDeviceHeight(context)/15,
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30),
                      //padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/20, right: Utils.getDeviceWidth(context)/20),
                      child: MaterialButton(
                        onPressed: () {
                          forgotEmail.text = "";
                          helpForgotEmailStr = "";
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: ColorRes.productBgGrey)),
                        child: Text(
                          StringRes.cancel,
                          style: TextStyle(color: ColorRes.cancelGreyText),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: Utils.getDeviceWidth(context)/30),
                      //padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/20, right: Utils.getDeviceWidth(context)/20),
                      child: MaterialButton(
                        color: ColorRes.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          StringRes.send,
                          style: TextStyle(color: ColorRes.white),
                        ),
                        onPressed: () {
                          forgotEmailValidation();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCreateProfile(UserData userData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateProfile(userData: userData)));
  }

  void navigateToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      //todo   here comment is actual right
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      ModalRoute.withName('/login'),
    );
  }

  Future<void> signInApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      SignInRequest rq = SignInRequest();
      rq.email = email.text;
      rq.password = password.text;

      CommonView.progressDialog(true, context);

      WebApi()
          .callAPI(
              Const.post, WebApi.rqLogin, rq.toJson(), Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          //Utils.showToast(StringRes.loginSuccess);
          UserData userData = UserData.fromJson(baseResponse.data);
          CommonView.progressDialog(false, context);

          if (userData.profileStatus == 1) {
            await Injector.updateUserData(userData);
            navigateToHomePage();
          } else {
            navigateToCreateProfile(userData);
          }
        } else {
          CommonView.progressDialog(false, context);
          setState(() {
            isLoading = false;
            helpPasswordStr = StringRes.doNotMatch;
            helpPassword = true;
          });
        }
      }).catchError((e) {
        print("login_" + e.toString());
        CommonView.progressDialog(false, context);
      });
    }
  }

  Future<void> socialLoginApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      SocialLoginRequest rq = SocialLoginRequest();
      rq.firstname = firstNameStr;
      rq.lastname = lastNameStr;
      rq.email = emailStr;
      rq.socialId = socialIdStr;
      rq.socialProvider = socialProviderStr;

      CommonView.progressDialog(true, context);

      WebApi().callAPI(
              Const.post, WebApi.rqSocial, rq.toJson(), Injector.accessToken)
          .then((data) async {
        CommonView.progressDialog(false, context);

        if (data.success) {
          if (data != null) {
            setState(() {
              isLoading = false;
            });
            UserData userData = UserData.fromJson(data.data);

            if (userData.profileStatus == 1) {
              await Injector.updateUserData(userData);
              navigateToHomePage();
            } else {
              //status 0
              navigateToCreateProfile(userData);
            }
          }
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
//        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  Future<void> forgotPasswordApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      ForgotPasswordRequest rq = ForgotPasswordRequest();
      rq.email = forgotEmail.text;

      setState(() {
        Navigator.pop(context);
        isLoading = true;
      });

      CommonView.progressDialog(true, context);


      WebApi()
          .callAPI(
              Const.post, WebApi.rqForgot, rq.toJson(), Injector.accessToken)
          .then((data) async {
        CommonView.progressDialog(false, context);

        setState(() {
          isLoading = false;
          forgotEmail.text = "";
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CommonView.customDialogSuccess(
                  context, StringRes.successFullySend, null);
            });
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
//        Utils.showToast(e.toString());
      });
    }
  }
}
