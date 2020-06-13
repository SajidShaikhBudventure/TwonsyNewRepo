import 'package:flutter/cupertino.dart';
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
import 'package:marketplace/model/register.dart';
import 'package:marketplace/model/social_login.dart';
import 'package:marketplace/screen/terms_conditions.dart';

import '../model/business_user.dart';
import 'create_profile.dart';
import 'home_page.dart';
import 'dart:io' show Platform;



//REGISTER PAGE


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool isLoading = false;

  GoogleSignInAccount _currentUser;

  bool firstNameRApi = false;
  bool lastNameRApi = false;
  bool emailNameRApi = false;
  bool passwordNameRApi = false;
  bool connPassWordNameRApi = false;

  bool helpFirstName = false;
  bool helpLastName = false;
  bool helpEmail = false;
  bool helpPassword = false;
  bool helpConPassword = false;

  String helpFirstStr = "";
  String helpLastStr = "";
  String helpEmailStr = "";
  String helpPasswordStr = "";
  String helpConPasswordStr = "";

  bool registerBtnShow = true;

  String firstNameStr;
  String lastNameStr;
  String emailStr;
  String socialIdStr;
  String socialProviderStr;

  @override
  void initState() {
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
          checkUserRegister();
        });
      }
    });
    Injector.googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    super.dispose();
  }

  keyboardShow() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        if (registerBtnShow == true) {
          setState(() {
            registerBtnShow = false;
          });
        } else {
          setState(() {
            registerBtnShow = true;
          });
        }
      },
    );
  }

  checkUserRegister() {
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
                /*Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: Platform.isAndroid ? CommonView.googleBtnShow(context) : Container(),
                ),*/
                registerLabel(),
                commonTextFiledView(1),
                commonTextFiledView(3),
                helpTextEmail(3),
                commonTextFiledView(4),
                helpTextEmail(4),
                commonTextFiledView(5),
                helpTextEmail(5),
                termsConditions(),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
        bottomNavigationBar: registerButton(),
      ),
    );
  }

  registerLabel() {
    return  Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: Utils.getDeviceHeight(context)/31),
      child: Text(
        "Create a new seller account",
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorRes.fontGrey, fontSize: Utils.getDeviceHeight(context)/32, fontFamily: FontRes.nunito),
      ),

    );
  }

  registerButton() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
      height: Utils.getDeviceHeight(context)/13,
      width: Utils.getDeviceWidth(context),
      color: ColorRes.black,
      child: MaterialButton(
        child: Text(
          StringRes.registerBtn,
          style: TextStyle(color: ColorRes.white, fontSize: Utils.getDeviceHeight(context)/42, fontFamily: FontRes.nunito),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          validateForm();
        },
      ),
    );
  }




  commonTextFiledView(int i) {
    return Container(
      height: i == 1 ? Utils.getDeviceHeight(context)/8.5 : Utils.getDeviceHeight(context)/13,
      margin: EdgeInsets.only(left: Utils.getDeviceWidth(context)/23, right: Utils.getDeviceWidth(context)/23, top: i == 3 ? 0: Utils.getDeviceHeight(context)/30),
      child: i == 1
          ? Row(
              children: <Widget>[
                Flexible(
                    child: Column(
                  children: <Widget>[
                    inputTextFiled(1),
                    helpTextEmail(1),
                  ],
                )),
                Padding(padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/23)),
                Flexible(
                    child: Column(
                  children: <Widget>[
                    inputTextFiled(2),
                    helpTextEmail(2),
                  ],
                )),
              ],
            )
          : inputTextFiled(i),
//                  child: inputTextFiled(),
    );
  }

  inputTextFiled(int i) {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: TextField(
        cursorColor: ColorRes.black,
        obscureText: i == 4 || i == 5 ? true : false,
        keyboardType: i == 3 ? TextInputType.emailAddress : TextInputType.text,
        controller: controllerTextFiled(i),
        decoration: InputDecoration(
          hintText: showHintText(i),
          hintStyle: TextStyle(color: ColorRes.greyText, fontFamily: FontRes.nunito),
        ),
        style: TextStyle(fontSize: Utils.getDeviceWidth(context)/28, color: ColorRes.black),
      ),
    );
  }

  termsConditions() {
    return Container(
      margin: EdgeInsets.only(top: Utils.getDeviceHeight(context)/40),
      padding: EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Container(
            width: Utils.getDeviceWidth(context),
            child: Text(
              StringRes.registerLine,
              style: TextStyle(fontSize: Utils.getDeviceHeight(context)/63, color: ColorRes.cancelGreyText, fontFamily: FontRes.nunito),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: Utils.getDeviceWidth(context),
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkResponse(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(StringRes.terms,
                        style: TextStyle(fontSize: Utils.getDeviceHeight(context)/63, color: ColorRes.blue, fontFamily: FontRes.nunito),
                        textAlign: TextAlign.center),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsConditions(type: 1)));
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(StringRes.and,
                      style: TextStyle(fontSize: Utils.getDeviceHeight(context)/63, color: ColorRes.cancelGreyText, fontFamily: FontRes.nunito),
                      textAlign: TextAlign.center),
                ),
                InkResponse(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(StringRes.privacy,
                        style: TextStyle(fontSize: Utils.getDeviceHeight(context)/63, color: ColorRes.blue, fontFamily: FontRes.nunito),
                        textAlign: TextAlign.center),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsConditions(type: 2)));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  showHintText(int i) {
    if (i == 1) {
      return StringRes.hintFirstName;
    } else if (i == 2) {
      return StringRes.hintLastName;
    } else if (i == 3) {
      return StringRes.hintEmail;
    } else if (i == 4) {
      return StringRes.hintPassword;
    } else if (i == 5) {
      return StringRes.hintConPassword;
    }
  }

  controllerTextFiled(int i) {
    if (i == 1) {
      return firstName;
    } else if (i == 2) {
      return lastName;
    } else if (i == 3) {
      return email;
    } else if (i == 4) {
      return password;
    } else if (i == 5) {
      return confirmPassword;
    }
  }

  helpTextEmail(int i) {
    return Visibility(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: i == 1 || i == 2 ? 0 : Utils.getDeviceHeight(context)/40, top: 3),
        child: Text(helpTitleShow(i),
            style: TextStyle(color: ColorRes.red, fontSize: Utils.getDeviceHeight(context)/70, fontFamily: FontRes.nunito)),
      ),
      visible: helpTextVisible(i),
    );
  }

  helpTextVisible(int i) {
    if (i == 1) {
      return helpFirstName;
    } else if (i == 2) {
      return helpLastName;
    } else if (i == 3) {
      return helpEmail;
    } else if (i == 4) {
      return helpPassword;
    } else if (i == 5) {
      return helpConPassword;
    }
  }

  helpTitleShow(int i) {
    if (i == 1) {
      return helpFirstStr;
    } else if (i == 2) {
      return helpLastStr;
    } else if (i == 3) {
      return helpEmailStr;
    } else if (i == 4) {
      return helpPasswordStr;
    } else if (i == 5) {
      return helpConPasswordStr;
    }
  }

  validateForm() async {
    firstNameVal();
    lastNameVal();
    emailVal();
    passwordVal();
    conPasswordVal();

    if (firstNameRApi &&
        lastNameRApi &&
        emailNameRApi &&
        passwordNameRApi &&
        connPassWordNameRApi) {
      registerApi();
    }

    setState(() {
      isLoading = false;
    });
  }

  firstNameVal() {
    if (firstName.text.isEmpty) {
      setState(() {
        helpFirstStr = StringRes.requiredFiled;
        helpFirstName = true;
        firstNameRApi = false;
      });
      return;
    } else {
      setState(() {
        helpFirstName = false;
        firstNameRApi = true;
      });
    }
  }

  lastNameVal() {
    if (lastName.text.isEmpty) {
      setState(() {
        helpLastStr = StringRes.requiredFiled;
        helpLastName = true;
        lastNameRApi = false;
      });
    } else {
      setState(() {
        helpLastName = false;
        lastNameRApi = true;
      });
    }
  }

  emailVal() {
    Pattern pattern = StringRes.emailValString;
    RegExp regex = new RegExp(pattern);
    if (email.text.isEmpty) {
      setState(() {
        helpEmailStr = StringRes.requiredFiled;
        helpEmail = true;
        emailNameRApi = false;
      });
      return;
    } else if (!regex.hasMatch(email.text)) {
      setState(() {
        helpEmailStr = StringRes.emailFiledVal;
        helpEmail = true;
        emailNameRApi = false;
      });
      return;
    } else {
      setState(() {
        helpEmail = false;
        emailNameRApi = true;
      });
    }
  }

  passwordVal() {
    if (password.text.isEmpty) {
      setState(() {
        helpPasswordStr = StringRes.requiredFiled;
        helpPassword = true;
        passwordNameRApi = false;
      });
      return;
    } else {
      setState(() {
        helpPassword = false;
        passwordNameRApi = true;
      });
    }
  }

  conPasswordVal() {
    if (confirmPassword.text.isEmpty) {
      setState(() {
        helpConPasswordStr = StringRes.requiredFiled;
        helpConPassword = true;
        connPassWordNameRApi = false;
      });
      return;
    } else if (confirmPassword.text != password.text) {
      setState(() {
        helpConPasswordStr = StringRes.passNotMatch;
        helpConPassword = true;
        connPassWordNameRApi = false;
      });
      return;
    } else {
      setState(() {
        helpConPassword = false;
        connPassWordNameRApi = true;
      });
    }
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
//      MaterialPageRoute(builder: (BuildContext context) => DrawerMenu()),
      //todo   here comment is actual right
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      ModalRoute.withName('/login'),
    );
  }

  Future<void> registerApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);
      RegisterRequest rq = RegisterRequest();
      rq.firstName = firstName.text;
      rq.lastName = lastName.text;
      rq.email = email.text;
      rq.password = password.text;

      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.post, WebApi.rqRegister, rq.toJson(),
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          CommonView.progressDialog(false, context);
          UserData userData = UserData.fromJson(baseResponse.data);

          setState(() {
            isLoading = false;
          });
          //Utils.showToast(baseResponse.message);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateProfile(userData: userData)));
          /*showDialog(
              context: context,
              builder: (BuildContext context) {
                return CommonView.customDialogSuccess(
                    context, baseResponse.message, userData);
              });*/
//          Injector.streamController?.add(StringRes.moveToLogin);

          setState(() {
            firstName.text = "";
            lastName.text = "";
            email.text = "";
            password.text = "";
            confirmPassword.text = "";
          });
        } else {
          CommonView.progressDialog(false, context);
          Utils.showToast(baseResponse.message);
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> socialLoginApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);
      SocialLoginRequest rq = SocialLoginRequest();
      rq.firstname = firstNameStr;
      rq.lastname = lastNameStr;
      rq.email = emailStr;
      rq.socialId = socialIdStr;
      rq.socialProvider = socialProviderStr;

      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(
              Const.post, WebApi.rqSocial, rq.toJson(), Injector.accessToken)
          .then((data) async {
        CommonView.progressDialog(false, context);

        if (data.success) {
          if (data != null) {
            UserData userData = UserData.fromJson(data.data);

            if (userData.profileStatus == 1) {
              await Injector.updateUserData(userData);
              navigateToHomePage();
            } else {
              //status 0
              navigateToCreateProfile(userData);
            }
          }
        } else {}
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        print("login_" + e.toString());
      });
    }
  }
}
