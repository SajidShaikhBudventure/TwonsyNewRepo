import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/prefkeys.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/model/session_request.dart';
import 'package:marketplace/model/slider_img_upload.dart';
import 'package:marketplace/screen/analytics_page.dart';
import 'package:marketplace/screen/main_page.dart';
import 'package:marketplace/screen/product_page.dart';
import 'package:marketplace/screen/rating_page.dart';
import 'package:marketplace/screen/support.dart';
import 'package:marketplace/screen/terms_conditions.dart';
import 'package:marketplace/screen/webView.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'businessInfo_page.dart';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<PhotosBusiness> arrImages = [];

  bool isLoading = false;
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String headerImage;

  String imagePath;
  String businessName;
  String businessAddress;

  String webProfile;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();

    _initPackageInfo();
    headerImage = Injector.userDataMain.profile;
    _tabController = new TabController(length: 4, vsync: this);

    DateTime now = DateTime.now();
    String sessionStart = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    Injector.prefs.setString(PrefKeys.sessionStart, sessionStart.toString());

    webProfile = Injector.prefs.getString(PrefKeys.webProfile);

    imageShowStream();
    getBusinessUserData();
    visitApi();
    checkUpdateApi();
//    Timer( Duration(seconds: 8), () => visitApi());

//    final anHourAgo = (new DateTime.now()) - Duration(minutes: Duration.minutesPerHour);

//    businessSessionAPI();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("====== resumed ======");
      DateTime now = DateTime.now();
      String sessionStart = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      Injector.prefs.setString(PrefKeys.sessionStart, sessionStart.toString());
    } else if (state == AppLifecycleState.inactive) {
      print("====== inactive ======");
      DateTime now = DateTime.now();
      String sessionEnd = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      businessSessionAPI(sessionEnd);
    } else if (state == AppLifecycleState.paused) {
      print("====== paused ======");
    } else if (state == AppLifecycleState.detached) {
      print("====== detached ======");
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  visitApi() {
    DateTime now = DateTime.now();
    var currentDate = new DateFormat('yyyy-MM-dd').format(now);
    var saveDate = Injector.prefs.getString(PrefKeys.todayDate);

    if (saveDate == null) {
      businessVisitApi();
    } else {
      if (saveDate == currentDate) {
        businessVisitApi();
      }
    }
  }

  businessVisitApi() {
    DateTime now = DateTime.now();

    String tomorrow =
        DateTime(now.year, now.month, now.day + 1).toIso8601String();
    String newString = tomorrow.substring(0, 10);
    Injector.prefs.setString(PrefKeys.todayDate, newString.toString());
    businessVisitAPI();
  }

  Future getImage(int type) async {
    Utils.getImage(type).then((file) {
      if (file != null) {
        PhotosBusiness photos = PhotosBusiness();
        photos.photo = file.path;
        arrImages.add(photos);
        uploadImgApi();
      }
    });
  }

  Future getImageSingle(int type) async {
    Utils.getImage(type).then((file) {
      if (file != null) {
        imagePath = file.path.toString();
        updateProfile(imagePath);
        setState(() {});
      }
    });
  }

  getImageDialog(int checkType) {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InkResponse(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Text(StringRes.choosePhoto),
                  alignment: Alignment.center,
                ),
                onTap: () {
                  Navigator.pop(context);
                  checkType == 2
                      ? getImage(Const.typeGallery)
                      : getImageSingle(Const.typeGallery);
                },
              ),
              Container(
                height: 1,
                color: ColorRes.fontGrey,
              ),
              InkResponse(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Text(StringRes.takePhoto),
                  alignment: Alignment.center,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  checkType == 2
                      ? getImage(Const.typeCamera)
                      : getImageSingle(Const.typeCamera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  imageShowStream() {
    Injector.streamController = StreamController.broadcast();

    Injector.streamController.stream.listen((data) {
      if (data == StringRes.sideImage) {
        headerImage = Injector.userDataMain.profile;
        businessName = Injector.prefs.getString(PrefKeys.businessName);
        businessAddress = Injector.prefs.getString(PrefKeys.businessAddress);
      }
      setState(() {});
    }, onDone: () {
      print("Task Done1");
      setState(() {});
    }, onError: (error) {
      print("Some Error1");
    });
  }

  int selectImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    imageShowStream();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          icon: Image.asset(
            Utils.getAssetsImg("menu"),
            color: ColorRes.white,
            height: Utils.getDeviceHeight(context) / 25,
            width: Utils.getDeviceHeight(context) / 25,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: showDrawerView(),
        ),
      ),
      body: showTabBar(),
    );
  }

  showDrawerView() {
    setState(() {});
    return Container(
//      color: ColorRes.colorPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showDrawerHeader(),
          showDrawerItems(),
        ],
      ),
    );
  }

  showDrawerHeader() {
    return Container(
        color: ColorRes.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /*InkResponse(
              child: Container(
                padding: const EdgeInsets.only(top: 35, right: 8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    Utils.getAssetsImg("menu"),
                    height: Utils.getDeviceHeight(context)/25,
                    width: Utils.getDeviceHeight(context)/25,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),*/

            InkResponse(
              child: Container(
                margin:
                    EdgeInsets.only(top: Utils.getDeviceHeight(context) / 14),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(top: 25),
                    height: Utils.getDeviceWidth(context) / 4,
                    width: Utils.getDeviceWidth(context) / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      border: Border.all(width: 1, color: ColorRes.white),
                      image: DecorationImage(
                          image: Injector.userDataMain.profile != null
                              ? NetworkImage(headerImage)
                              : AssetImage(Utils.getAssetsImg("profile")),
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
              ),
              onTap: () {
                //getImageDialog(1);
              },
            ),
            Container(
              margin: EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: Utils.getDeviceHeight(context) / 29,
                    width: Utils.getDeviceWidth(context),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        right: Utils.getDeviceHeight(context) / 100,
                        left: Utils.getDeviceHeight(context) / 110,
                        top: Utils.getDeviceHeight(context) / 100),
                    child: Text(businessName.toString(),
                        style: TextStyle(
                            color: ColorRes.white,
                            fontSize: Utils.getDeviceHeight(context) / 44),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: Utils.getDeviceHeight(context) / 29,
                    width: Utils.getDeviceWidth(context),
                    margin: EdgeInsets.only(
                        right: Utils.getDeviceHeight(context) / 100,
                        left: Utils.getDeviceHeight(context) / 110,
                        bottom: Utils.getDeviceHeight(context) / 90,
                        top: Utils.getDeviceHeight(context) / 150),
                    //padding: EdgeInsets.only(top: 1),

                    child: Text(businessAddress.toString(),
                        style: TextStyle(
                            color: ColorRes.white,
                            fontSize: Utils.getDeviceHeight(context) / 44),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  logOutApis() async {
    print("tap logout");
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });
      WebApi()
          .callAPI(Const.get, WebApi.rqLogout, null, Injector.accessToken)
          .then((data) async {
        if (data.success) {
          print("tap logout");
          Injector.prefs.remove(PrefKeys.todayDate);
          Injector.prefs.remove(PrefKeys.webProfile);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainLoginPage()),
            ModalRoute.withName('/login'),
          );
          _handleSignOut();
          await Injector.prefs.clear();
          Injector.accessToken = null;
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _handleSignOut() async {
    if (Injector.currentUser == null) {
      setState(() {
        Injector.googleSignIn.disconnect();
      });
    }
  }

  _launchURL() async {
    // Android and iOS
//     uri = webProfile;
    if (await canLaunch(webProfile)) {
      await launch(webProfile);
    } else {
      throw 'Could not launch $webProfile';
    }
  }

  showDrawerItems() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
                left: Utils.getDeviceHeight(context) / 60, right: 10.0, top: 0),
            title: Text(
              StringRes.viewOnTownsy,
              style: TextStyle(
                  color: ColorRes.black,
                  fontSize: Utils.getDeviceHeight(context) / 38),
            ),
            onTap: () {
              Navigator.pop(context);
              _launchURL();
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewPage(webUrl: webProfile)));*/
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: Utils.getDeviceHeight(context) / 60, right: 10.0, top: 0),
            title: Text(
              StringRes.guidelines,
              style: TextStyle(
                  color: ColorRes.black,
                  fontSize: Utils.getDeviceHeight(context) / 38),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsConditions(type: 3)));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: Utils.getDeviceHeight(context) / 60, right: 10.0),
            title: Text(
              StringRes.support,
              style: TextStyle(
                  color: ColorRes.black,
                  fontSize: Utils.getDeviceHeight(context) / 38),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SupportPage()));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: Utils.getDeviceHeight(context) / 60, right: 10.0),
            title: Text(
              StringRes.logout,
              style: TextStyle(
                  color: ColorRes.black,
                  fontSize: Utils.getDeviceHeight(context) / 38),
            ),
            onTap: () {
              logOutApis();
            },
          ),
        ],
      ),
    );
  }

  Widget showTabBar() {
    return Column(
      children: <Widget>[
        Container(
          height: Utils.getDeviceHeight(context) / 3.3,
          child: Stack(
            children: <Widget>[
              Container(
                  width: Utils.getDeviceWidth(context),
                  color: ColorRes.sliderBg,
                  child: arrImages.isNotEmpty
                      ? Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return arrImages[index].photo.contains("http")
                                ? Image.network(arrImages[index].photo)
                                : Image.file(File(arrImages[index].photo));
                          },
                          index: selectImageIndex,
                          onIndexChanged: (i) {
                            selectImageIndex = i;
                            print("indez__" + selectImageIndex.toString());
                          },
                          autoplay: false,
                          itemCount: arrImages.length,
                          pagination: new SwiperPagination(),
                          control: new SwiperControl(),
                          loop: false,
                        )
                      : Center(
                          child: Image(
                              height: Utils.getDeviceHeight(context) / 8,
                              width: Utils.getDeviceHeight(context) / 8,
                              image: AssetImage(Utils.getAssetsImg("shop")),
                              fit: BoxFit.fitHeight),
                        )),
              rightSideIcon(2),
            ],
          ),
        ),
        Container(
          color: ColorRes.black,
          height: Utils.getDeviceHeight(context) / 12,
          child: TabBar(
            indicatorColor: ColorRes.white,
            isScrollable: false,
            tabs: <Tab>[
              Tab(child: tabBarText(StringRes.businessInfo, context, 1)),
              Tab(child: tabBarText(StringRes.products, context, 2)),
              Tab(child: tabBarText(StringRes.ratingsReviews, context, 3)),
              Tab(child: tabBarText(StringRes.analytics, context, 4)),
            ],
            controller: _tabController,
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              BusinessPage(),
              ProductPage(),
              RatingPage(),
              AnalyticsPage(),
            ],
            controller: _tabController,
          ),
        )
      ],
    );
  }

  rightSideIcon(int delete) {
    return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkResponse(
                  onTap: () {
                    getImageDialog(2);
                  },
//                  onTap: getImage,
                  child: Icon(
                    Icons.add_to_photos,
                    color: ColorRes.white,
                    size: Utils.getDeviceWidth(context) / 15,
                  ),
                ),
              ),
              arrImages.isNotEmpty && arrImages.length > 1
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkResponse(
                        onTap: () {
                          deleteImgApi(arrImages[selectImageIndex].id);
                        },
                        child: Icon(
                          Icons.close,
                          color: ColorRes.white,
                          size: Utils.getDeviceWidth(context) / 15,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

//API
  Future<void> uploadImgApi() async {
    Utils.isInternetConnected().then((isConnected) {
      PhotoUploadRequest rq = PhotoUploadRequest();
//      rq.photos = _images.;
      print("Hello $arrImages");
      setState(() {
        isLoading = true;
      });

      List<File> arrFile = List();

      arrImages.forEach((image) {
        if (!image.photo.contains("http")) arrFile.add(File(image.photo));
      });

      if (arrFile.isNotEmpty) {
        WebApi()
            .uploadImgApi(WebApi.rqBusinessPhoto, Injector.accessToken, arrFile)
            .then((baseResponse) async {
          if (baseResponse != null) {
            if (baseResponse.success) {
              arrImages.clear();

              baseResponse.data.forEach((v) {
                arrImages.add(PhotosBusiness.fromJson(v));
              });
            } else {
              Utils.showToast(baseResponse.message);
            }
          }
        }).catchError((e) {
          print("image uploading." + e.toString());
          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }

  updateProfile(String imagePath) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);

      WebApi()
          .editProfile(WebApi.userProfile, new File(imagePath))
          .then((baseResponse) async {
        CommonView.progressDialog(false, context);

        if (baseResponse != null && baseResponse.success) {
          Utils.showToast(baseResponse.message);

          headerImage = baseResponse.data['profile'];
          Injector.userDataMain.profile = headerImage;

          Injector.updateUserData(Injector.userDataMain);
          Injector.streamController?.add(StringRes.sideImage);
          setState(() {});
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  //get all business data

  getBusinessUserData() async {
    print("businessUserData function call");
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.get, WebApi.rqBusinessMe, null, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          UserBusinessData userBusinessData =
              UserBusinessData.fromJson(baseResponse.data);

          Injector.userDataMain.businessName = userBusinessData.businessName;
          Injector.userDataMain.address = userBusinessData.address;
          Injector.userDataMain.profileStatus = userBusinessData.profileStatus;
          arrImages = userBusinessData.photos;

          webProfile = userBusinessData.webProfile;
          Injector.prefs
              .setString(PrefKeys.webProfile, userBusinessData.webProfile);

//          Injector.userDataMain.photos = userBusinessData.photos;

          Injector.updateUserData(Injector.userDataMain);

//          await Injector.updateBusinessData(userBusinessData);

          headerImage = Injector.userDataMain.profile;

          setState(() {
            isLoading = false;

          });
        } else {
          Utils.showToast(baseResponse.message);
        }
      }).catchError((e) {
        print(WebApi.rqBusinessMe + "_" + e.toString());
        setState(() {
          isLoading = false;
        });
        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  Future<void> deleteImgApi(int id) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.delete, "${WebApi.rqBusinessPhoto}/$id", null,
              Injector.accessToken)
          .then((data) async {
        if (data.success) {
          Utils.showToast(data.message);

          arrImages.removeWhere((photo) => photo.id == id);

          setState(() {});
        } else {
          Utils.showToast(data.message);
        }
      }).catchError((e) {
        print("delete_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  businessSessionAPI(String sessionEnd) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    DateTime now = DateTime.now();

    String sessionSave =
        Injector.prefs.getString(PrefKeys.sessionStart.toString());

    print(sessionSave);
    SessionStartEnd rq = SessionStartEnd();
    rq.sessionStart = sessionSave;
    rq.sessionEnd = sessionEnd;

    if (isConnected) {
      CommonView.progressDialog(true, context);

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.session, rq.toJson(),
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          print("seccess");
//            Utils.showToast("sessionStart");
          CommonView.progressDialog(false, context);
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
      });
    }
  }

  businessVisitAPI() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

//    String sessionSave = Injector.prefs.getString(PrefKeys.sessionStart.toString());

    if (isConnected) {
      CommonView.progressDialog(true, context);

      WebApi()
          .callAPI(Const.get, WebApi.visit, null, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          print("seccess");
          CommonView.progressDialog(false, context);
//          Utils.showToast("visit API");

        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
      });
    }
  }

  checkUpdateApi() async {
    print("businessUserData function call");
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      String platForm;
      if (Platform.isAndroid) {
        // Android-specific code
        platForm = 'android';
      } else if (Platform.isIOS) {
        // iOS-specific code
        platForm = 'iOS';
      }

      CommonView.progressDialog(true, context);
//
      WebApi()
          .callAPI(
              Const.getReqNotToken,
              WebApi.update + '?v=${_packageInfo.version}&type=$platForm',
              null,
              null)
          .then((baseResponse) async {
        CommonView.progressDialog(false, context);

        if (baseResponse.success) {
          int flag = baseResponse.data['flag'];

          if (flag == 0) {
//https://play.google.com/store/apps/details?id=YOUR-APP-ID

            return;
          } else if (flag == 1) {
            //https://play.google.com/store/apps/details?id=YOUR-APP-ID
            showAlertUpgrade(1);
          } else if (flag == 2) {
            //https://play.google.com/store/apps/details?id=YOUR-APP-ID
            showAlertUpgrade(2);
          }
          setState(() {});
        }
      }).catchError((e) {
        print("login_" + e.toString());
        CommonView.progressDialog(true, context);
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  showAlertUpgrade(int i) {
    showDialog(
      barrierDismissible: false, // JUST MENTION THIS LINE
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(StringRes.upgradeTitle),
          content: new Text(StringRes.upgradeDetails),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            i == 2
                ? FlatButton(
                    child: new Text(StringRes.later,
                        style: TextStyle(color: ColorRes.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : Container(),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                StringRes.updateNow,
                style: TextStyle(color: ColorRes.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}

//tabbar Text

tabBarText(String tabName, BuildContext context, int index) {
  /* return Container(
    child: Text(
      tabName,
      maxLines: 3,
      style: TextStyle(
          fontFamily: "assets/fonts/Nunito-Regular",
          fontSize: Utils.getDeviceWidth(context) / 42,
          fontWeight: FontWeight.w500,
          height: 1.2),
      textAlign: TextAlign.center,
    ),
  );*/

  return AutoSizeText(
    tabName,
    style: TextStyle(
        fontSize: Utils.getDeviceWidth(context) / 20,
        fontFamily: "assets/fonts/Nunito-Regular",
        fontWeight: FontWeight.w500),
    textAlign: TextAlign.center,
    minFontSize: 5,
    maxLines: index == 1 || index == 3 ? 2 : 1,
    overflow: TextOverflow.ellipsis,
  );
}