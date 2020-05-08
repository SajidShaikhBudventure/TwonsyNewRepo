import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketplace/helper/res.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 40.0,
          color: Colors.transparent,
          child: new Center(
            child: SpinKitThreeBounce(color: ColorRes.white),
          )),
    );
  }
}
