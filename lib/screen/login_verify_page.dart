import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/model/create_profile.dart';
import 'package:marketplace/model/send_otp.dart';
import 'package:marketplace/screen/home_page.dart';
import 'dart:io' show Platform;

class LoginVerifyPage extends StatefulWidget {
  final BusinessCreateRequest businessCreateRequest;
  final String mobile;
  final UserData userData;

  const LoginVerifyPage(
      {Key key, this.businessCreateRequest, this.mobile, this.userData})
      : super(key: key);

  @override
  _LoginVerifyPageState createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  final FocusNode one = FocusNode();
  final FocusNode two = FocusNode();
  final FocusNode three = FocusNode();
  final FocusNode four = FocusNode();
  final FocusNode five = FocusNode();
  final FocusNode six = FocusNode();

  TextEditingController oneText = TextEditingController();
  TextEditingController twoText = TextEditingController();
  TextEditingController threeText = TextEditingController();
  TextEditingController fourText = TextEditingController();
  TextEditingController fiveText = TextEditingController();
  TextEditingController sixText = TextEditingController();

  bool textShow = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringRes.verifyMobile,
          style: TextStyle(fontSize: Utils.getDeviceWidth(context)/21),
        ),
      ),
      body: Container(
          color: ColorRes.white,
          width: Utils.getDeviceWidth(context),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      child: SingleChildScrollView(
                          child: Stack(
                        children: <Widget>[mainContain()],
                      )),
                    )),
                    Container(
                      child: MaterialButton(
                        height: Utils.getDeviceHeight(context)/13,
                        minWidth: Utils.getDeviceWidth(context),
                        color: ColorRes.black,
                        child: Text(
                          StringRes.next,
                          style: TextStyle(color: ColorRes.white),
                        ),
                        onPressed: () {
                          otpSendApi();
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 0,
                color: ColorRes.transparent,
              )
            ],
          )),
    );
  }

  mainContain() {
    return Column(
      children: <Widget>[
        Container(
          width: Utils.getDeviceWidth(context) / 1.08,
          padding: EdgeInsets.only(top: 60, bottom: 30),
          child: Text(
            StringRes.enterOtp,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorRes.black,
                fontSize: Utils.getDeviceWidth(context) / 27, height: Platform.isAndroid? 1.2 : 1.3),
          ),
        ),
        Container(
          width: Utils.getDeviceWidth(context),
          margin: EdgeInsets.only(left: Utils.getDeviceWidth(context)/10, right: Utils.getDeviceWidth(context)/10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: firstTextFiled(),
              ),
              new Padding(padding: new EdgeInsets.only(left: Utils.getDeviceWidth(context)/30)),
              Flexible(
                child: twoTextFiled(),
              ),
              new Padding(padding: new EdgeInsets.only(left: Utils.getDeviceWidth(context)/30)),
              Flexible(
                child: threeTextFiled(),
              ),
              new Padding(padding: new EdgeInsets.only(left: Utils.getDeviceWidth(context)/30)),
              Flexible(
                child: fourTextFiled(),
              ),
              new Padding(padding: new EdgeInsets.only(left:Utils.getDeviceWidth(context)/30)),
              Flexible(
                child: fiveTextFiled(),
              ),
              new Padding(padding: new EdgeInsets.only(left: Utils.getDeviceWidth(context)/30)),
              Flexible(
                child: sixTextFiled(),
              ),
            ],
          ),
        ),
        Visibility(
          child: Container(
            width: Utils.getDeviceWidth(context),
            padding: EdgeInsets.only(top: 30, bottom: 0),
            child: Text(StringRes.invalidOtp,
                style: TextStyle(color: ColorRes.otpRedText, fontSize: Utils.getDeviceWidth(context)/27),
                textAlign: TextAlign.center),
          ),
          visible: textShow,
        ),
        InkResponse(
          child: Container(
            width: Utils.getDeviceWidth(context),
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(StringRes.resendOtp,
                style: TextStyle(color: ColorRes.lightBlueText, fontSize: Utils.getDeviceWidth(context)/27),
                textAlign: TextAlign.center),
          ),
          onTap: () {
            reSendApi();
          },
        ),
      ],
    );
  }

  firstTextFiled() {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        color: ColorRes.white,
        height: 45,
        child: TextFormField(
            textAlign: TextAlign.center,
            obscureText: true,
            controller: oneText,
            autofocus: true,
            cursorColor: ColorRes.black,
            textInputAction: TextInputAction.next,
            focusNode: one,
            keyboardType: TextInputType.number,
            onChanged: (String newVal) {
              if (newVal.length == 1) {
                one.unfocus();
                FocusScope.of(context).requestFocus(two);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            decoration: decoration(),
            style: textStyle()),
      ),
    );
    ;
  }

  twoTextFiled() {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        color: ColorRes.white,
        height: 45,
        child: TextFormField(
          textAlign: TextAlign.center,
          obscureText: true,
          controller: twoText,
          cursorColor: ColorRes.black,
          autofocus: true,
          textInputAction: TextInputAction.next,
          focusNode: two,
          keyboardType: TextInputType.number,
          onChanged: (String newVal) {
            if (newVal.length == 1) {
              two.unfocus();
              FocusScope.of(context).requestFocus(three);
            } else if (newVal.length == 0){
              two.unfocus();
              FocusScope.of(context).requestFocus(one);
            }
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: decoration(),
          style: textStyle(),
        ),
      ),
    );
  }

  threeTextFiled() {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        color: ColorRes.white,
        height: 45,
        child: TextFormField(
          textAlign: TextAlign.center,
          obscureText: true,
          autofocus: true,
          cursorColor: ColorRes.black,
          controller: threeText,
          textInputAction: TextInputAction.next,
          focusNode: three,
          keyboardType: TextInputType.number,
          onChanged: (String newVal) {
            if (newVal.length == 1) {
              three.unfocus();
              FocusScope.of(context).requestFocus(four);
            } else if (newVal.length == 0) {
              three.unfocus();
              FocusScope.of(context).requestFocus(two);
            }
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: decoration(),
          style: textStyle(),
        ),
      ),
    );
  }

  fourTextFiled() {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        color: ColorRes.white,
        height: 45,
        child: TextFormField(
          textAlign: TextAlign.center,
          obscureText: true,
          autofocus: true,
          cursorColor: ColorRes.black,
          controller: fourText,
          textInputAction: TextInputAction.next,
          focusNode: four,
          keyboardType: TextInputType.number,
          onChanged: (String newVal) {
            if (newVal.length == 1) {
              four.unfocus();
              FocusScope.of(context).requestFocus(five);
            } else if (newVal.length == 0) {
              four.unfocus();
              FocusScope.of(context).requestFocus(three);
            }
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: decoration(),
          style: textStyle(),
        ),
      ),
    );
  }

  fiveTextFiled() {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        color: ColorRes.white,
        height: 45,
        child: TextFormField(
          textAlign: TextAlign.center,
          obscureText: true,
          autofocus: true,
          cursorColor: ColorRes.black,
          controller: fiveText,
          textInputAction: TextInputAction.next,
          focusNode: five,
          keyboardType: TextInputType.number,
          onChanged: (String newVal) {
            if (newVal.length == 1) {
              five.unfocus();
              FocusScope.of(context).requestFocus(six);
            } else if (newVal.length == 0) {
              five.unfocus();
              FocusScope.of(context).requestFocus(four);
            }
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: decoration(),
          style: textStyle(),
        ),
      ),
    );
  }

  sixTextFiled() {
    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        color: ColorRes.white,
        height: 45,
        child: TextFormField(
          textAlign: TextAlign.center,
          obscureText: true,
          autofocus: true,
          cursorColor: ColorRes.black,
          controller: sixText,
          textInputAction: TextInputAction.next,
          focusNode: six,
          keyboardType: TextInputType.number,
          onChanged: (String newVal) {
            if (newVal.length == 0) {
              six.unfocus();
              FocusScope.of(context).requestFocus(five);
            }
          },
          onFieldSubmitted: (term) {
            otpSendApi();
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: decoration(),
          style: textStyle(),
        ),
      ),
    );
  }

  decoration() {
    return InputDecoration(
      hintText: "●",
      hintStyle: TextStyle(color: ColorRes.fontGrey, fontSize: Utils.getDeviceWidth(context)/25),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorRes.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorRes.black),
      ),
    );
  }

  textStyle() {
    return TextStyle(fontSize: 25, color: ColorRes.black);
  }

  // API create business
  createBusinessProfile() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(
              Const.postWithAccess,
              WebApi.rqBusiness,
              widget.businessCreateRequest.toJson(),
              widget.userData.auth.accessToken)
          .then((data) async {
        if (data != null && data.success) {
          await Injector.updateUserData(widget.userData);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('/home'),
          );
          setState(() {});
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  otpSendApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);

      String otp = oneText.text +
          twoText.text +
          threeText.text +
          fourText.text +
          fiveText.text +
          sixText.text;

      VerifyRequest rq = VerifyRequest();
      rq.otp = otp;

      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.verifyOtp, rq.toJson(),
              widget.userData.auth.accessToken)
          .then((baseResponse) async {
        CommonView.progressDialog(false, context);

        if (baseResponse.success) {
          createBusinessProfile();
        } else {
          textShow = true;

          setState(() {});
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
        print("otpverify_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  reSendApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);

      setState(() {
        isLoading = true;
      });

      SendOtpRequest rq = SendOtpRequest();
      rq.phone = widget.mobile;
      rq.countryCode = StringRes.sendNineOne;

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.sendOtp, rq.toJson(),
              widget.userData.auth.accessToken)
          .then((baseResponse) async {
        CommonView.progressDialog(false, context);

        if (baseResponse != null && baseResponse.success) {
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
}
