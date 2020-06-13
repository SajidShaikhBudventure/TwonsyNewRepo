import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/screen/terms_conditions.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SUPPORT", style: TextStyle(fontSize: Utils.getDeviceWidth(context)/21)),
      ),
      body: fullView(),
      bottomNavigationBar: bottomView(),
    );
  }

  fullView() {
    return Container(
      width: Utils.getDeviceWidth(context),
      height: Utils.getDeviceHeight(context)*12/13,
      margin: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          firstLineText(),
          secondLineImage(),
          threePhone(),
          fourthEmail(),
          fifthFacebook(),
        ],
      ),
    );
  }

  firstLineText() {
    return Container(
      height: Utils.getDeviceHeight(context)/20,
      width:  Utils.getDeviceWidth(context),
      margin: EdgeInsets.only(right: 0, left:0, top: Utils. getDeviceHeight(context)/12),
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/24, right: Utils. getDeviceWidth(context)/24),
      alignment: Alignment(0,0),
      child: Text(StringRes.weAreHere, style: Theme.of(context).textTheme.title.copyWith(fontSize: Utils.getDeviceWidth(context)/18), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  secondLineImage() {
    return Container(
      height: Utils.getDeviceHeight(context)/4,
      width:  Utils.getDeviceWidth(context),
      margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/20),
      alignment: Alignment(0,0),
      child: Image.asset(
        Utils.getAssetsImg("customer_service"),
        height: Utils.getDeviceHeight(context)/2,
        width: Utils.getDeviceWidth(context)/2,
      ),
    );
  }

  threePhone() {
    return Container(
      height: Utils.getDeviceHeight(context)/20,
      width:  Utils.getDeviceWidth(context),
      margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/20),
      alignment: Alignment(0,0),
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, right: Utils. getDeviceWidth(context)/30),
      child: Container(
        color: ColorRes.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //color: ColorRes.black,
              width: Utils.getDeviceWidth(context)*3/8,
              alignment: Alignment(0,0),
              padding: EdgeInsets.only(left: 8, right: 4),
              child: Center(
                child: Text(
                "CALL US ON:",
                  style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28, color: ColorRes.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border.all(color: ColorRes.black, width: 1)),
                child: InkWell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        "+91 7683084157",
                        style: TextStyle(
                            fontSize: Utils.getDeviceWidth(context) / 30),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  onTap: () {
                    //_launchURL();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  fourthEmail() {
    return Container(
      height: Utils.getDeviceHeight(context)/20,
      width:  Utils.getDeviceWidth(context),
      margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/40),
      alignment: Alignment(0,0),
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, right: Utils. getDeviceWidth(context)/30),
      child: Container(
        color: ColorRes.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //color: ColorRes.black,
              width: Utils.getDeviceWidth(context)*3/8,
              alignment: Alignment(0,0),
              padding: EdgeInsets.only(left: 8, right: 3),
              child: Center(
                child: Text(
                  StringRes.emailAt,
                  style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28, color: ColorRes.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border.all(color: ColorRes.black, width: 1)),
                child: InkWell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        "SUPPORT@TOWNSY.IN",
                        style: TextStyle(
                            fontSize: Utils.getDeviceWidth(context) / 31),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  onTap: () {
                    _launchURL();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  fifthFacebook() {
    return Container(
      height: Utils.getDeviceHeight(context)/20,
      width:  Utils.getDeviceWidth(context),
      margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/40,bottom: Utils. getDeviceHeight(context)/10 ),
      alignment: Alignment(0,0),
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, right: Utils. getDeviceWidth(context)/30),
      child: Container(
        color: ColorRes.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text("REACH US ON ",
                      style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28, color: ColorRes.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    alignment: Alignment.center,
                    child: Image(
                        height: 15,
                        width: 15,
                        image: AssetImage(Utils.getAssetsImg("facebook"))),
                  ),
                  Container(
                    child: Text(" :", style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28, color: ColorRes.white)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                //height: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border.all(color: ColorRes.black, width: 1)),
                child: InkWell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "@TOWNSYINDIA",
                        style: TextStyle(
                            fontSize: Utils.getDeviceWidth(context) / 30,
                            color: ColorRes.lightBlueText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  onTap: () {
                    launchURLFaceBook();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bottomView() {
    return Container(
      height: Utils.getDeviceHeight(context)/13,
      margin: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: Utils.getDeviceHeight(context)/26,
            width:  Utils.getDeviceWidth(context),
            alignment: Alignment(0,0),
            margin: EdgeInsets.only(top:0, bottom:0, right: 0, left: 0),
            child: InkWell(
              child: Text(
                StringRes.privacyPolicy,
                style: TextStyle(color: ColorRes.lightBlueText), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsConditions(type: 2)
                    )
                );
              },
            ),
          ),
          Container(
            height: Utils.getDeviceHeight(context)/26,
            width:  Utils.getDeviceWidth(context),
            alignment: Alignment(0,0),
            margin: EdgeInsets.only(top:0, bottom:0, right: 0, left: 0),
            child: InkWell(
              child: Text(
                StringRes.termsConditions,
                style: TextStyle(color: ColorRes.lightBlueText), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsConditions(type: 1)));
              },
            ),
          ),
    ],
      ),
    );
  }

  _launchURL() async {
    // Android and iOS
    const uri = 'mailto:SUPPORT@TOWNSY.IN?subject=&body=';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  launchURLFaceBook() async {
    const url = 'https://www.facebook.com/TownsyIndia';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
