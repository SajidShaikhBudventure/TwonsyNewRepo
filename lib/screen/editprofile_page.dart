import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/business_user.dart';

import '../injection/dependency_injection.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  bool isLoading = false;

  UserBusinessData userBusinessData = UserBusinessData();
  String imagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName.text = Injector.userDataMain.firstname.toString();
    lastName.text = Injector.userDataMain.lastname.toString();
    imagePath = Injector.userDataMain.profile;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery);
    if (image != null) {
      imagePath = image.path.toString();
    }
    setState(() {});
  }

  imageShow() {
    return imagePath != null && imagePath.isNotEmpty
        ? imagePath.contains("http")
            ? NetworkImage(imagePath)
            : FileImage(File(imagePath))
        : AssetImage(Utils.getAssetsImg("profile"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringRes.editProfile),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0.0),
        child: Column(
          children: <Widget>[
            InkResponse(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 30, left: 30, right: 10, bottom: 10),
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageShow(), fit: BoxFit.cover)),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkResponse(
                      child: Icon(Icons.add_a_photo),
                      onTap: () {
                        getImage();
                      },
                    ),
                  )
                ],
              ),
              onTap: () {
                getImage();
              },
            ),
            Container(
              child: textFiledEmail(),
            ),
            Container(
              child: textFiledPassword(),
            ),
            Container(
              height: 35,
              width: 100,
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: ColorRes.black,
              ),
              child: InkResponse(
                child: Text(
                  StringRes.save,
                  style: TextStyle(color: ColorRes.white),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  updateProfile();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  textFiledEmail() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: TextField(
        cursorColor: ColorRes.black,
        controller: firstName,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,

        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorRes.fontGrey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.greyText),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.black),
          ),
        ),
        style: TextStyle(fontSize: 14, color: ColorRes.black),
      ),
    );
  }

  textFiledPassword() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: TextField(
        cursorColor: ColorRes.black,
        controller: lastName,
        maxLines: 1,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorRes.fontGrey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.greyText),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.black),
          ),
        ),
        style: TextStyle(fontSize: 14, color: ColorRes.black),
      ),
//                  child: inputTextFiled(),
    );
  }

  //update profile : -

  updateProfile() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .editProfile(WebApi.userProfile, new File(imagePath))
          .then((baseResponse) async {
        if (baseResponse != null && baseResponse.success) {
          setState(() {
            isLoading = false;
          });

          Utils.showToast(baseResponse.message);
//          getBusinessUserData();
          Injector.streamController?.add(StringRes.sideImage);
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  getBusinessUserData() async {
    print("businessUserData function call");
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(
              Const.get, WebApi.rqBusinessMe, null, Injector.accessToken)
          .then((data) async {
        if (data.success) {
          UserBusinessData userBusinessData =
              UserBusinessData.fromJson(data.data);

          firstName.text = userBusinessData.firstname;
          lastName.text = userBusinessData.lastname;

          Injector.userDataMain.firstname = userBusinessData.firstname;
          Injector.userDataMain.lastname = userBusinessData.lastname;
          Injector.userDataMain.profile = userBusinessData.profile;
          Injector.updateUserData(Injector.userDataMain);

          setState(() {});
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
