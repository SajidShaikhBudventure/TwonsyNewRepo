import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/screen/create_profile.dart';

class CommonView {
  static progressDialog(bool isLoading, BuildContext context) {
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      elevation: 0.0,
      content: new Container(
          height: 40.0,
          color: Colors.transparent,
          child: new Center(
            child: SpinKitThreeBounce(color: ColorRes.white),
          )),
    );
    if (!isLoading) {
      Navigator.of(context).pop();
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  static Widget customDialogSuccess(BuildContext context, String message, UserData userData) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: StringRes.successFullySend == message ? 110 : 145,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Container(
                  height: StringRes.successFullySend == message ? 30 : 75,
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                child: Container(
                  child: MaterialButton(
                    color: ColorRes.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      StringRes.done,
                      style: TextStyle(color: ColorRes.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if(StringRes.successFullySend != message) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateProfile(userData: userData)));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  static Widget googleBtnShow(BuildContext context) {
    return InkResponse(
      child: Container(
        alignment: Alignment(0, 0),
        height: Utils.getDeviceHeight(context) / 15,
        width: Utils.getDeviceWidth(context) * 0.85,
        decoration: BoxDecoration(
            color: ColorRes.black,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: EdgeInsets.symmetric(
            vertical: Utils.getDeviceHeight(context) / 80,
            horizontal: Utils.getDeviceWidth(context) / 50),
        margin: EdgeInsets.only(
            top: Utils.getDeviceHeight(context) / 30,
            bottom: Utils.getDeviceHeight(context) / 30,
            left: Utils.getDeviceWidth(context) / 20,
            right: Utils.getDeviceWidth(context) / 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                StringRes.continueGoogle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Utils.getDeviceWidth(context) / 25,
                    color: ColorRes.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: Utils.getDeviceHeight(context) / 18,
              width: Utils.getDeviceHeight(context) / 18,
              margin: EdgeInsets.only(top: 0, bottom: 0, right: 0),
              //padding: EdgeInsets.only(left: 8, top: 0),
              alignment: Alignment(0, 0),
              child: Image(image: AssetImage(Utils.getAssetsImg("google"))),
            )
          ],
        ),
      ),
      onTap: () async {
        progressDialog(true, context);

        await _handleSignIn();

        progressDialog(false, context);
      },
    );
  }

  static Future<void> _handleSignIn() async {
    try {
      bool isSignIn = await Injector.googleSignIn.isSignedIn();

      if (isSignIn) {
        await Injector.googleSignIn.signOut();
      }

      Injector.googleSignIn.signIn();
//          .then((account) {
//        print(account.displayName);
//      }).catchError((e) {
//        Utils.showToast(e.toString());
//      });
    } catch (error) {
      print(error);
    }
  }
}
