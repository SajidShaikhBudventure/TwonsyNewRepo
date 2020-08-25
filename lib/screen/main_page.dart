import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/screen/register_page.dart';
import 'package:marketplace/screen/signin_page.dart';
import 'dart:io' show Platform;

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  bool isLoading = false;

  int showLoginOrNot = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: ColorRes.white,
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: Utils.getDeviceHeight(context) / 4.5,
                  floating: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Container(
                        width: Utils.getDeviceWidth(context),
                        color: ColorRes.black,
                        margin: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                        height: Utils.getDeviceHeight(context) / 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              StringRes.townsyTitle,
                              style: TextStyle(
                                  fontSize: Utils.getDeviceHeight(context)/17,
                                  color: ColorRes.white,
                                  fontWeight: FontWeight.w700,
                              fontFamily: FontRes.nunito),
                            ),
                            SizedBox(height: Utils.getDeviceWidth(context)/60),
                            Text(
                              StringRes.newbusinessTitle,
                              style: TextStyle(
                                  fontSize: Utils.getDeviceHeight(context)/21,
                                  color: ColorRes.white,
                                  fontWeight: FontWeight.w700,
                              fontFamily: FontRes.nunito),
                            )
                          ],
                        ),
                      )),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: ColorRes.white,
                      labelStyle: TextStyle(fontSize: Utils.getDeviceWidth(context)/27, fontFamily: FontRes.nunito),
                      unselectedLabelColor: ColorRes.lightGrey,
                      indicatorColor: ColorRes.white,
                      tabs: [
                        Tab(text: StringRes.register),
                        Tab(text: StringRes.signIn),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(children: [
              Container(
                color: ColorRes.black,
                child: RegisterPage(),
              ),
              Container(
                color: ColorRes.black,
                child: LoginPage(),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  showHeaderImage() {
    return Container(
      width: Utils.getDeviceWidth(context),
      color: ColorRes.black,
      height: Utils.getDeviceHeight(context) / 4.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            StringRes.townsyTitle,
            style: TextStyle(
                fontSize: Utils.getDeviceHeight(context)/15,
                color: ColorRes.white,
                fontWeight: FontWeight.w800, fontFamily: FontRes.nunito),
          ),
          SizedBox(height: Utils.getDeviceWidth(context)/60),
          Text(
            StringRes.businessTitle,
            style: TextStyle(
                fontSize: Utils.getDeviceHeight(context)/19,
                color: ColorRes.white,
                fontWeight: FontWeight.w700,
            fontFamily: FontRes.nunito),
          )
        ],
      ),
    );
  }

  showTabBar() {
    Injector.streamController = StreamController.broadcast();

    Injector.streamController.stream.listen((data) {
      if (data == StringRes.moveToLogin) {
        setState(() {
          showLoginOrNot = 1;
        });
      }
    }, onDone: () {
      print("Task Done1");
      setState(() {});
    }, onError: (error) {
      print("Some Error1");
    });

    return DefaultTabController(
      length: 2,
      initialIndex: showLoginOrNot,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(height: 50),
            child: TabBar(indicatorColor: ColorRes.white, tabs: <Tab>[
              Tab(
                text: StringRes.register,
              ),
              Tab(text: StringRes.signIn),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: ColorRes.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
