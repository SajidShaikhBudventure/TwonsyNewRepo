import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/screen/terms_conditions.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToPage extends StatefulWidget {
  @override
  _HowToPageState createState() => _HowToPageState();
}

class _HowToPageState extends State<HowToPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOW TO USE"),
      ),
      body: body(),
    );
  }
  body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
      width: Utils.getDeviceWidth(context),
      //height: Utils.getDeviceHeight(context),
      margin: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          firstQuestion(),
          firstAnswer(),
          secondQuestion(),
          secondAnswer(),
          thirdQuestion(),
          thirdAnswer(),
          fourthQuestion(),
          fourthAnswer(),
          fifthQuestion(),
          fifthAnswer(),
        ],
      ),
    )]
)
    );
  }

  firstQuestion(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.all(Utils.getDeviceWidth(context)/25),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/40),
      //alignment: Alignment(0,0),
      child: Text(StringRes.firstQ, style: Theme.of(context).textTheme.title.copyWith(fontSize: Utils.getDeviceWidth(context)/23, fontWeight: FontWeight.w600)),
    );
  }

  firstAnswer(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.only(right: Utils.getDeviceWidth(context)/25, left: Utils.getDeviceHeight(context)/30, bottom: Utils.getDeviceHeight(context)/50),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/50),
      alignment: Alignment.topLeft,
      child: Text(StringRes.firstA, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
    );
  }

  secondQuestion(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.all(Utils.getDeviceWidth(context)/25),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/25),
      //alignment: Alignment(0,0),
      child: Text(StringRes.secondQ, style: Theme.of(context).textTheme.title.copyWith(fontSize: Utils.getDeviceWidth(context)/23, fontWeight: FontWeight.w600)),
    );
  }

  secondAnswer(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.only(right: Utils.getDeviceWidth(context)/25, left: Utils.getDeviceHeight(context)/30, bottom: Utils.getDeviceHeight(context)/50),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/50),
      alignment: Alignment.topLeft,
      child: Text(StringRes.secondA, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
    );
  }

  thirdQuestion(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.all(Utils.getDeviceWidth(context)/25),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/25),
      //alignment: Alignment(0,0),
      child: Text(StringRes.thirdQ, style: Theme.of(context).textTheme.title.copyWith(fontSize: Utils.getDeviceWidth(context)/23, fontWeight: FontWeight.w600)),
    );
  }

  thirdAnswer(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.only(right: Utils.getDeviceWidth(context)/25, left: Utils.getDeviceHeight(context)/30, bottom: Utils.getDeviceHeight(context)/50),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/50),
      alignment: Alignment.topLeft,
      child: Text(StringRes.thirdA, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
    );
  }

  fourthQuestion(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.all(Utils.getDeviceWidth(context)/25),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/25),
      //alignment: Alignment(0,0),
      child: Text(StringRes.fourthQ, style: Theme.of(context).textTheme.title.copyWith(fontSize: Utils.getDeviceWidth(context)/23, fontWeight: FontWeight.w600)),
    );
  }

  fourthAnswer(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.only(right: Utils.getDeviceWidth(context)/25, left: Utils.getDeviceHeight(context)/30, bottom: Utils.getDeviceHeight(context)/50),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/50),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(StringRes.fourthA1, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
          Container(
            //height: Utils.getDeviceHeight(context)/2,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: Utils. getDeviceHeight(context)/50),
            alignment: Alignment(0,0),
            child: Image.asset(
              Utils.getAssetsImg("HowTo1"),
              //height: Utils.getDeviceHeight(context)/2,
              //width: Utils.getDeviceWidth(context)/2,
            ),
          ),
          Text(StringRes.fourthA2, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
          Container(
            //height: Utils.getDeviceHeight(context)/2,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: Utils. getDeviceHeight(context)/50),
            alignment: Alignment(0,0),
            child: Image.asset(
              Utils.getAssetsImg("HowTo2"),
              //height: Utils.getDeviceHeight(context)/2,
              //width: Utils.getDeviceWidth(context)/2,
            ),
          ),
          Text(StringRes.fourthA3, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
          Container(
            //height: Utils.getDeviceHeight(context)/2,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: Utils. getDeviceHeight(context)/50),
            alignment: Alignment(0,0),
            child: Image.asset(
              Utils.getAssetsImg("HowTo3a"),
              //height: Utils.getDeviceHeight(context)/2,
              //width: Utils.getDeviceWidth(context)/2,
            ),
          ),
          Container(
            //height: Utils.getDeviceHeight(context)/2,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: Utils. getDeviceHeight(context)/50),
            alignment: Alignment(0,0),
            child: Image.asset(
              Utils.getAssetsImg("HowTo3b"),
              //height: Utils.getDeviceHeight(context)/2,
              //width: Utils.getDeviceWidth(context)/2,
            ),
          ),
          Text(StringRes.fourthA4, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
          Container(
            //height: Utils.getDeviceHeight(context)/2,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: 0),
            alignment: Alignment(0,0),
            child: Image.asset(
              Utils.getAssetsImg("HowTo4"),
              //height: Utils.getDeviceHeight(context)/2,
              //width: Utils.getDeviceWidth(context)/2,
            ),
          ),
        ],),
    );
  }

  fifthQuestion(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.all(Utils.getDeviceWidth(context)/25),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/25),
      //alignment: Alignment(0,0),
      child: Text(StringRes.fifthQ, style: Theme.of(context).textTheme.title.copyWith(fontSize: Utils.getDeviceWidth(context)/23, fontWeight: FontWeight.w600)),
    );
  }

  fifthAnswer(){
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.white,
      padding: EdgeInsets.only(right: Utils.getDeviceWidth(context)/25, left: Utils.getDeviceHeight(context)/30, bottom: Utils.getDeviceHeight(context)/50),
      margin: EdgeInsets.only(left: 0, right:0, top: Utils.getDeviceHeight(context)/50, bottom: Utils.getDeviceHeight(context)/30),
      alignment: Alignment.topLeft,
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(StringRes.fifthA, style: TextStyle(fontSize: Utils.getDeviceWidth(context)/24, fontWeight: FontWeight.w200, height: Utils.getDeviceHeight(context)/800),textAlign: TextAlign.justify),
        Container(
          //height: Utils.getDeviceHeight(context)/2,
          //width:  Utils.getDeviceWidth(context),
          margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: Utils. getDeviceHeight(context)/50),
          alignment: Alignment(0,0),
          child: Image.asset(
            Utils.getAssetsImg("HowTo5"),
            //height: Utils.getDeviceHeight(context)/2,
            //width: Utils.getDeviceWidth(context)/2,
          ),
        ),
        Container(
          //height: Utils.getDeviceHeight(context)/2,
          //width:  Utils.getDeviceWidth(context),
          margin: EdgeInsets.only(right: 0, left: 0, top: Utils. getDeviceHeight(context)/30, bottom: 0),
          alignment: Alignment(0,0),
          child: Image.asset(
            Utils.getAssetsImg("HowTo6"),
            //height: Utils.getDeviceHeight(context)/2,
            //width: Utils.getDeviceWidth(context)/2,
          ),
        ),
      ],),
    );
  }
}