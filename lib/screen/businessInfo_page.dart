import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/prefkeys.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/mapLib/flutter_google_places.dart';
import 'package:marketplace/model/business_type_model.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/model/create_profile.dart';
import 'package:marketplace/screen/home_page.dart';
import 'dart:io' show Platform;

import '../helper/res.dart';
import '../helper/utils.dart';
import 'main_page.dart';
import 'package:google_maps_webservice/places.dart';

class BusinessPage extends StatefulWidget {
  @override
  _BusinessPageState createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  bool editBusinessInfo = false;
  bool checkBoxTime = false;

  bool manufacturer = false;
  bool wholeSeller = false;
  bool retailer = false;

  bool isLoading = true;

  int publicPrivet;

//  bool isName = false;
  bool isPublicPrivet = false;
  bool isForBusinessAddress = false;
  bool isForBusiness = false;
  bool isForCategory = false;

  bool isForBusinessTypeNull = false;

  int otherBusinessTypes;
  bool isSelectTimeInvalid = false;

  String latitude;
  String longitude;

  List<int> showBusinessType = List();
  final _formKey = GlobalKey<FormState>();
  final _formKeyForCategory = GlobalKey<FormState>();
  TextEditingController businessNameTF = TextEditingController();
  TextEditingController businessAddressTF = TextEditingController(text: "");
  TextEditingController mobileTF = TextEditingController();
  TextEditingController telephoneTF = TextEditingController();
  TextEditingController businessCatTF = TextEditingController();
  TextEditingController otherInfoTF = TextEditingController();
  TextEditingController categoryTF = TextEditingController();
  TextEditingController categoryListTF = TextEditingController();

  List<Time> selectDayList;
  List<Time> dayTimeList = List();

  List<String> categoryList = new List<String>();

  List<BusinessTypeModel> businessTypeList = new List<BusinessTypeModel>();
  List<int> businessTypeDisplayList = new List<int>();

  bool isForMobileNumber = false;
  bool isForMobileNumber10Limit = false;
  bool isForTelephoneNumber = false;
  bool isForOtherInfo = false;
  bool isSelectBusinessType = false;
  bool isSelectDateTime = false;

  int makeProfileCheck;

  List<int> indexOfNumber = [1, 2, 3];

  String webProfile;

  List<Day> dayList = [
    Day(name: StringRes.monday, isCheck: false),
    Day(name: StringRes.tuesday, isCheck: false),
    Day(name: StringRes.wednesday, isCheck: false),
    Day(name: StringRes.thursday, isCheck: false),
    Day(name: StringRes.friday, isCheck: false),
    Day(name: StringRes.saturday, isCheck: false),
    Day(name: StringRes.sunday, isCheck: false),
  ];

  List<String> checkDay = [
    StringRes.checkMonday,
    StringRes.checkTuesday,
    StringRes.checkWednesday,
    StringRes.checkThursday,
    StringRes.checkFriday,
    StringRes.checkSaturday,
    StringRes.checkSunday
  ];

  TextEditingController addCategorytext = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 7; i++) {
      dayTimeList.add(Time(
          day: arrDay[i],
          startTime: "08:00",
          endTime: "22:00",
          isCheck: false));
    }

    getBusinessTypeList();
    getBusinessUserData();

  }

  @override
  Widget build(BuildContext context) {
    if (isLoading != null && isLoading) {
      return Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitThreeBounce(
            color: ColorRes.black,
            size: Utils.getDeviceWidth(context) / 20,
          )
        ],
      ));
    }
    return Scaffold(
      body: Form(
        key: _formKey,
        child: InkResponse(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                titleText(StringRes.businessName, 1),
                nameTextFiled(),
                addresstitleText(StringRes.businessAddress, 2),
                addressTextFiled(),
                titleText(StringRes.phoneNumber, 3),
                telephoneNumberView(),
                mobileNumberView(),
                titleText(StringRes.openingTime, 4),
                dateTimeView(),
                invalidTime(),
                titleText(StringRes.businessCategory, 5),
                busDesTitleText(StringRes.businessDes),
                categoryTextFiled(),
                addCategory(),
                selectedCategoryList(),
                titleText(StringRes.businessType, 6),
                businessType(),
                titleText("Other Info For Customers", 7),
                noReturnTextFiled(),
                lastSaveBtn()
              ],
            ),
          ),
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }

  nameTextFiled() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 200,
          right: Utils.getDeviceWidth(context) / 30,
          left: Utils.getDeviceWidth(context) / 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: Container(
              color: ColorRes.white,
              height: Utils.getDeviceHeight(context) / 16,
              child: TextFormField(
                maxLines: 1,
                autocorrect: false,
                controller: businessNameTF,
                enabled: editBusinessInfo,
                cursorColor: ColorRes.black,
                style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
                onChanged: (text) {
                  print(text);
                  isForBusiness = true;
                  if (text.isEmpty) {
                  } else {
                    isForBusiness = false;
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isForBusiness = true;
                    });
                  } else {
                    setState(() {
                      isForBusiness = false;
                    });
                  }
                  return null;
                },
              ),
            ),
          ),
          isForBusiness
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    StringRes.requiredFiled,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: ColorRes.validationColorRed),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  displayPrediction(Prediction p) async {
    try {
      if (p != null) {
        businessAddressTF.text = p.description.toString();
        var addresses =
            await Geocoder.local.findAddressesFromQuery(p.description);
        print(addresses.first.coordinates.latitude.toString() +
            "=====>" +
            addresses.first.coordinates.longitude.toString());

        latitude = addresses.first.coordinates.latitude.toString();
        Injector.prefs.setString(PrefKeys.latitude, latitude);
        longitude = addresses.first.coordinates.longitude.toString();
        Injector.prefs.setString(PrefKeys.longitude, longitude);

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Widget addresstitleText(String title, int type) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: Utils.getDeviceWidth(context) / 25,
          top: Utils.getDeviceHeight(context) / 50,
          bottom: Utils.getDeviceHeight(context) / 120),
      child: editBusinessInfo
      ?Text(
        title,
        style: TextStyle(
            fontSize: Utils.getDeviceWidth(context) / 32,
            fontWeight: FontWeight.w700),
      )
          :Text(
        "City Located",
        style: TextStyle(
            fontSize: Utils.getDeviceWidth(context) / 32,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  addressTextFiled() {
    Prediction p;

    return Theme(
      data: ThemeData(primaryColor: ColorRes.black),
      child: Container(
        margin: EdgeInsets.only(
            top: Utils.getDeviceHeight(context) / 200,
            right: Utils.getDeviceWidth(context) / 30,
            left: Utils.getDeviceWidth(context) / 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            editBusinessInfo
                ? InkResponse(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 12, bottom: 15, left: 8, right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: ColorRes.white,
                          border: Border.all(color: ColorRes.black, width: 1)),
                      child: Text(
                          businessAddressTF == null
                              ? ""
                              : businessAddressTF.text,
                          style:
                              TextStyle(color: ColorRes.black, fontSize: 13)),
                    ),
                    onTap: () async {
                      p = await PlacesAutocomplete.show(
                          context: context,
                          mode: Mode.overlay,
                          apiKey: StringRes.googleAddress);
                      displayPrediction(p);

                      setState(() {});
                    },
                  )
                : Container(
                    color: ColorRes.white,
                    child: Theme(
                      data: ThemeData(primaryColor: ColorRes.black),
                      child: Container(
                        color: ColorRes.white,
                        child: TextFormField(
                          cursorColor: ColorRes.black,
                          controller: businessAddressTF,
                          enabled: editBusinessInfo,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                              fontSize: Utils.getDeviceWidth(context) / 28),
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: const BorderSide(color: Colors.black, width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                isForBusinessAddress = true;
                              });
                            } else {
                              setState(() {
                                isForBusinessAddress = false;
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    )),
            isForBusinessAddress
                ? Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      StringRes.requiredFiled,
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: ColorRes.validationColorRed),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  telephoneNumberView() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 100,
          left: Utils.getDeviceWidth(context) / 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                  right: Utils.getDeviceWidth(context) / 30,
                  left: 0,
                  top: 0,
                  bottom: 0),
              child: Image(
                  height: Utils.getDeviceHeight(context) / 25,
                  width: Utils.getDeviceHeight(context) / 25,
                  image: AssetImage(Utils.getAssetsImg("telephone")))),
          Container(
            width: Utils.getDeviceWidth(context) * 2 / 5,
            height: Utils.getDeviceHeight(context) / 16,
            margin: EdgeInsets.only(top: 0),
            child: telePhoneNumberAddText(),
          ),
        ],
      ),
    );
  }

  mobileNumberView() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 100,
          left: Utils.getDeviceWidth(context) / 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                  right: Utils.getDeviceWidth(context) / 30, left: 0, top: 0),
              child: Image(
                  height: Utils.getDeviceHeight(context) / 25,
                  width: Utils.getDeviceHeight(context) / 25,
                  image: AssetImage(Utils.getAssetsImg("phone")))),
          Container(
            width: Utils.getDeviceWidth(context) * 2 / 5,
            height: Utils.getDeviceHeight(context) / 16,
            child: phoneNumberAddText(),
          )
        ],
      ),
    );
  }


  invalidTime() {
    return Visibility(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
            left: Utils.getDeviceWidth(context) / 25,
            top: Utils.getDeviceHeight(context) / 100),
        child: Text( StringRes.timeInvalid,
          style:
          Theme.of(context).textTheme.caption.copyWith(color: ColorRes.red),
        ),
      ),
      visible: isSelectTimeInvalid,
    );
  }

  dateTimeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.fromLTRB(
              Utils.getDeviceWidth(context) / 30, 10, 8, 10),
          children: List.generate(dayList.length, (index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                editBusinessInfo
                    ? InkResponse(
                        onTap: () {
                          dayTimeList[index].isCheck =
                              !dayTimeList[index].isCheck;
                          setState(() {});
                        },
                        child: Image.asset(
                          Utils.getAssetsImg(dayTimeList[index].isCheck
                              ? "checked_img"
                              : "unchecked_img"),
                          height: editBusinessInfo == true ? 20 : 0,
                          width: editBusinessInfo == true ? 20 : 0,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    dayList[index].name,
                    style: TextStyle(
                        fontSize: Utils.getDeviceWidth(context) / 28,
                        color: dayList[index].isCheck
                            ? ColorRes.greyText
                            : ColorRes.black),
                  ),
                ),
                dayTimeList[index].isCheck
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            startTime(index),
                            Container(child: Text(" - ")),
                            endTime(index)
                          ],
                        ),
                      )
                    : Row(
                        children: <Widget>[
                          Container(
                            height: 25,
                            padding: EdgeInsets.only(right: 35),
                            margin: EdgeInsets.only(right: 0, top: 8),
                            child: Text(
                              StringRes.closed,
                              style: TextStyle(
                                  color: ColorRes.overallGreyText,
                                  fontSize: Utils.getDeviceWidth(context) / 28),
                            ),
                          ),
                        ],
                      )
              ],
            );
          }),
        ),
        isSelectDateTime
            ? Padding(
                padding: EdgeInsets.only(
                    left: Utils.getDeviceWidth(context) / 30, bottom: 10),
                child: Text(
                  StringRes.requiredFiled,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: ColorRes.validationColorRed),
                ),
              )
            : Container()
      ],
    );
  }

  dateTimeValidation() {
    return Visibility(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15, top: 5),
        child: Text(
          StringRes.requiredFiled,
          style: TextStyle(color: ColorRes.validationColorRed, fontSize: 12),
        ),
      ),
      visible: isSelectDateTime,
    );
  }

  busDesTitleText(String title) {
    return editBusinessInfo
    ?Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: Utils.getDeviceWidth(context) / 25,
          bottom: Utils.getDeviceHeight(context) / 50,
          right: Utils.getDeviceWidth(context) / 25),
      child: Text(
        title,
        style: TextStyle(
            height: Platform.isAndroid?1.1:1.25,
            color: ColorRes.lightGrey,
            fontSize: Utils.getDeviceHeight(context) / 60),
        textAlign: TextAlign.justify,
      ),
    )
        :Container();
  }

  Widget categoryTextFiled() {
    return Center(
      child:
      editBusinessInfo
      ?Container(
        margin: EdgeInsets.only(
            top: Utils.getDeviceHeight(context) / 200,
            right: Utils.getDeviceWidth(context) / 30,
            left: Utils.getDeviceWidth(context) / 30),
        child: Form(
          key: _formKeyForCategory,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: Utils.getDeviceHeight(context) / 16,
                color: ColorRes.white,
                child: Theme(
                  data: ThemeData(primaryColor: ColorRes.black),
                  child: TextFormField(
                    cursorColor: ColorRes.black,
                    autocorrect: false,
                    enabled: editBusinessInfo,
                    controller: categoryTF,
                    style:
                        TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 0.0, right: 10, left: 10),
                      border: OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: StringRes.hintOfBusinessCategory,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isForCategory = true;
                        });
                      } else {
                        setState(() {
                          isForCategory = false;
                        });
                      }
                      return null;
                    },
                  ),
                ),
              ),
              isForCategory
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        StringRes.requiredFiled,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: ColorRes.validationColorRed),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      )
      :Container(),
    );
  }

  Widget selectedCategoryList() {
    if (categoryList != null && categoryList.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(categoryList.length, (index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorRes.lightGrey),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, left: 12.0, bottom: 5.0, right: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      categoryList[index],
                      style: TextStyle(
                          fontSize: Utils.getDeviceWidth(context) / 28),
                    )),
                    editBusinessInfo
                    ?InkResponse(
                      child: Icon(Icons.delete_outline),
                      onTap: () {
                        if (editBusinessInfo) {
                          confirmationDialog(index);
                        }
                      },
                    )
                        :Container(),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Container();
    }
  }

  addCategory() {
    return
      editBusinessInfo
      ?InkResponse(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /*Container(
            padding: EdgeInsets.only(right: 0, top: 3),
            child: Image(
                height: 40,
                width: 40,
                image: AssetImage(Utils.getAssetsImg("plus_blue"))),
          ),*/
          Container(
            padding: EdgeInsets.only(right: 10, top: 15, bottom: 15),
            child: Text(
              StringRes.addCategory,
              style: TextStyle(
                  fontSize: Utils.getDeviceWidth(context) / 28,
                  color: ColorRes.lightBlueText),
            ),
          )
        ],
      ),
      onTap: () {
        if (editBusinessInfo) {
          if (_formKeyForCategory.currentState.validate()) {
            _formKeyForCategory.currentState.save();
            if (categoryTF.text.isNotEmpty &&
                categoryTF.text.toString() != null) {
              categoryList.add(categoryTF.text.toString());
              categoryTF.text = "";
              setState(() {});
            }
          }
        }
      },
    )
          :Container(margin: EdgeInsets.only(top: 7),);
  }

  businessType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        editBusinessInfo
            ? ListView(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.fromLTRB(
                    Utils.getDeviceWidth(context) / 25, 0, 10, 10),
                children: List.generate(businessTypeList.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: Utils.getDeviceWidth(context) / 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        editBusinessInfo
                            ? InkResponse(
                                onTap: () {
                                  businessTypeList[index].isSelectedType =
                                      !businessTypeList[index].isSelectedType;
                                  setState(() {});
                                },
                                child: Image.asset(
                                  Utils.getAssetsImg(
                                      businessTypeList[index].isSelectedType
                                          ? "checked_img"
                                          : "unchecked_img"),
                                  width: Utils.getDeviceHeight(context) / 30,
                                  height: Utils.getDeviceHeight(context) / 30,
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: editBusinessInfo ? 10 : 0,
                        ),
                        Expanded(
                            child: Text(
                          businessTypeList[index].businessTypes,
                          style: TextStyle(
                              fontSize: Utils.getDeviceWidth(context) / 28),
                        ))
                      ],
                    ),
                  );
                }),
              )
            : ListView(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                children:
                    List.generate(businessTypeDisplayList.length, (index) {
                  String businessType;
                  switch (businessTypeDisplayList[index]) {
                    case 1:
                      businessType = StringRes.manufacturer;
                      break;
                    case 2:
                      businessType = StringRes.wholeSeller;
                      break;
                    case 3:
                      businessType = StringRes.retailer;
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      businessType,
                      style: TextStyle(
                          fontSize: Utils.getDeviceWidth(context) / 25),
                    ),
                  );
                }),
              ),
        isForBusinessTypeNull
            ? Padding(
                padding: EdgeInsets.only(
                    left: Utils.getDeviceWidth(context) / 25,
                    top: 8.0,
                    bottom: 10),
                child: Text(
                  StringRes.requiredFiled,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: ColorRes.validationColorRed),
                ),
              )
            : Container()
      ],
    );
  }

  noReturnTextFiled() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 200,
          right: Utils.getDeviceWidth(context) / 30,
          left: Utils.getDeviceWidth(context) / 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: Container(
              color: ColorRes.white,
              child: TextFormField(
                autocorrect: false,
                cursorColor: ColorRes.black,
                controller: otherInfoTF,
                enabled: editBusinessInfo,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  ),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  allDayList(int index) {
    return Row(
      children: <Widget>[],
    );
  }

  startTime(int index) {
    var newTime;

    return editBusinessInfo == true
        ? InkResponse(
            child: startTimeBox(index),
            onTap: () {
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  showSecondsColumn: false, onChanged: (date) {
                var startTime = date.toString();
                newTime = startTime.substring(11, 16);
                print(newTime);
              }, onConfirm: (date) {
                    print('confirm $DateTime.now()');
                    String tempEndTime = newTime;

                    int housStart =
                    int.parse(dayTimeList[index].endTime.substring(0, 2));
                    int housEnd = int.parse(tempEndTime.substring(0, 2));

                    int minutStart =
                    int.parse(dayTimeList[index].endTime.substring(3, 5));
                    int minutEnd = int.parse(tempEndTime.substring(3, 5));

                    if (housStart >= housEnd) {
                      if (minutStart >= minutEnd) {
                        setState(() {
                          dayTimeList[index].startTime = newTime;
                          isSelectTimeInvalid = false;
                        });
                      } else {
                        setState(() {
                          dayTimeList[index].startTime = newTime;
                          isSelectTimeInvalid = true;
                        });
                      }
                    } else {
                      setState(() {
                        dayTimeList[index].startTime = newTime;
                        isSelectTimeInvalid = true;
                      });
                    }
                  }, currentTime: DateTime.now());
            },
          )
        : startTimeBox(index);
  }

  startTimeBox(int index) {
    return Container(
        padding: EdgeInsets.all(4),
        decoration: editBusinessInfo == true
            ? BoxDecoration(
                border: Border.all(color: ColorRes.rateBoxBorder, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              )
            : BoxDecoration(),
        child: Text(dayTimeList[index].startTime ?? "08:45",
            style: TextStyle(fontStyle: FontStyle.normal,
                fontSize: Utils.getDeviceWidth(context) / 28)));
  }

  endTime(int index) {
    var newTime;

    return editBusinessInfo == true
        ? InkResponse(
            child: endTimeBox(index),
            onTap: () {
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  showSecondsColumn: false, onChanged: (date) {
                var endTime = date.toString();
                newTime = endTime.substring(11, 16);
                print(newTime);
              }, onConfirm: (date) {
                    print('confirm $DateTime.now()');
                    String tempEndTime = newTime;

                    int housStart =
                    int.parse(dayTimeList[index].startTime.substring(0, 2));
                    int housEnd = int.parse(tempEndTime.substring(0, 2));

                    int minutStart =
                    int.parse(dayTimeList[index].startTime.substring(3, 5));
                    int minutEnd = int.parse(tempEndTime.substring(3, 5));

                    if (housStart <= housEnd) {
                      if (minutStart <= minutEnd) {
                        setState(() {
                          dayTimeList[index].endTime = newTime;
                          isSelectTimeInvalid = false;
                        });
                      } else {
                        setState(() {
                          dayTimeList[index].endTime = newTime;
                          isSelectTimeInvalid = true;
                        });
                      }
                    } else {
                      setState(() {
                        dayTimeList[index].endTime = newTime;
                        isSelectTimeInvalid = true;
                      });
                    }
                  }, currentTime: DateTime.now());
            },
          )
        : endTimeBox(index);
  }

  endTimeBox(int index) {
    return Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(right: 10),
        decoration: editBusinessInfo == true
            ? BoxDecoration(
                border: Border.all(color: ColorRes.rateBoxBorder, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              )
            : BoxDecoration(),
        child: Text(
          dayTimeList[index].endTime ?? "08:45",
          style: TextStyle(
            fontStyle: FontStyle.normal,
              fontSize: Utils.getDeviceWidth(context) / 28
          ),
        ));
  }

  Widget titleText(String title, int type) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: Utils.getDeviceWidth(context) / 25,
          top: Utils.getDeviceHeight(context) / 50,
          bottom: Utils.getDeviceHeight(context) / 120),
      child: Text(
        title,
        style: TextStyle(
            fontSize: Utils.getDeviceWidth(context) / 32,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  businessTypeCheckBox(bool checkBusinessInfo, int type) {
    return Container(
      child: Visibility(
        child: Checkbox(
          value: checkBoxTime,
          onChanged: (bool value) {
            setState(() {
              checkBoxTime = value;
            });
          },
        ),
        visible: editBusinessInfo,
      ),
    );
  }

  businessTypeText(String text) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 0, right: 7),
      child: Text(
        text,
        style: TextStyle(color: ColorRes.black),
      ),
    );
  }

  Widget phoneNumberAddText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Theme(
          data: ThemeData(primaryColor: ColorRes.black),
          child: Container(
            color: ColorRes.white,
            height: Utils.getDeviceHeight(context) / 18,
            child: TextFormField(
              cursorColor: ColorRes.black,
              controller: mobileTF,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.left,
              maxLines: 1,
              enabled: editBusinessInfo,
              style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  setState(() {
                    isForMobileNumber = true;
                  });
                } else {
                  if (value.length < 10) {
                    isForMobileNumber10Limit = true;
                    isForMobileNumber = true;
                  } else {
                    isForMobileNumber10Limit = false;
                    isForMobileNumber = false;
                  }
                  setState(() {});
                }
                return null;
              },
            ),
          ),
        ),
        isForMobileNumber
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  isForMobileNumber10Limit != null && isForMobileNumber10Limit
                      ? StringRes.enterTenDigit
                      : StringRes.requiredFiled,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: ColorRes.validationColorRed),
                ),
              )
            : Container()
      ],
    );
  }

  Widget telePhoneNumberAddText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Theme(
          data: ThemeData(primaryColor: ColorRes.black),
          child: Container(
            color: ColorRes.white,
            height: Utils.getDeviceHeight(context) / 18,
            child: TextFormField(
              cursorColor: ColorRes.black,
              controller: telephoneTF,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.left,
              maxLines: 1,
              enabled: editBusinessInfo,
              style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          ),
        ),
        isForTelephoneNumber
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  StringRes.requiredFiled,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: ColorRes.validationColorRed),
                ),
              )
            : Container()
      ],
    );
  }

  lastSaveBtn() {
    return Column(
      children: <Widget>[
        editBusinessInfo == false
            ? editText(StringRes.editBusinessInfo)
            : Container(
                margin: EdgeInsets.only(top: 30),
                height: Utils.getDeviceHeight(context) / 12,
                color: ColorRes.black,
                width: Utils.getDeviceWidth(context),
                child: MaterialButton(
                    child: Text(
                      StringRes.save,
                      style: TextStyle(color: ColorRes.white),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      isForBusinessTypeNull = !businessTypeList
                          .where((buisness) => buisness.isSelectedType)
                          .toList()
                          .isNotEmpty;

                      isSelectDateTime = !dayTimeList
                          .where((buisness) => buisness.isCheck)
                          .toList()
                          .isNotEmpty;

                      isForCategory = !categoryList
                          .where((buisness) => buisness.length > 0)
                          .toList()
                          .isNotEmpty;

                      setState(() {});

                      if (_formKey.currentState.validate()) {
                        if (!isForBusiness &&
                            !isForCategory &&
                            !isSelectDateTime &&
                            !isSelectTimeInvalid &&
                            !isForBusinessTypeNull) {
                          List<String> businessList = new List();
                          for (int i = 0; i < businessTypeList.length; i++) {
                            if (businessTypeList[i].isSelectedType) {
                              businessList.add(businessTypeList[i]
                                  .businessTypesInInt
                                  .toString());
                            }
                          }

                          updateBusinessProfile();
                        }
                      }
                    }),
              ),
        Visibility(
          child: profileAndDeleteText(
              //isPublicPrivet
              makeProfileCheck == 1
                  ? StringRes.markProfilePublic
                  : StringRes.markProfilePrivate,
              1),
          visible: !editBusinessInfo,
        ),
        Visibility(
          child: profileAndDeleteText(StringRes.deleteBusinessProfile, 2),
          visible: !editBusinessInfo,
        ),
        editBusinessInfo != true
            ? Padding(padding: EdgeInsets.only(bottom: 20))
            : Padding(padding: EdgeInsets.only(bottom: 0, top: 0))
      ],
    );
  }

  confirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(StringRes.delete),
          content: new Text(StringRes.deleteCategoryMsg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(StringRes.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(StringRes.yes),
              onPressed: () {
                Navigator.of(context).pop();
                if (editBusinessInfo) {
                  categoryList.removeAt(index);
                }
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  editText(String stringName) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
      child: InkResponse(
        child:
            Text(stringName, style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28, color: ColorRes.lightBlueText)),
        onTap: () {
          setState(() {
            if (editBusinessInfo == false) {
              editBusinessInfo = true;
            } else {
              editBusinessInfo = false;
            }
          });
        },
      ),
    );
  }

  profileAndDeleteText(String stringName, int type) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 10, left: 10, top: 12),
      child: InkResponse(
        child: Text(stringName, style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28, color: ColorRes.lightRedText)),
        onTap: () {
          type == 1 ? onTapPublic() : deleteBusinessAlert();
        },
      ),
    );
  }

  onTapPublic() {
    if (makeProfileCheck == 1) {
      profilePublicPrivate(0);
      makeProfileCheck = 0;
    } else {
      profilePublicPrivate(1);
      makeProfileCheck = 1;
    }
  }

  deleteBusinessAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
              height: Utils.getDeviceHeight(context) / 3.7,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 12, right: 12, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          StringRes.deleteBusinessMsg,
                          style: TextStyle(
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                              fontSize: Utils.getDeviceHeight(context) / 45),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: Utils.getDeviceWidth(context) / 30,
                              top: 15),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side:
                                    BorderSide(color: ColorRes.productBgGrey)),
                            child: Text(
                              StringRes.cancel,
                              style: TextStyle(color: ColorRes.cancelGreyText),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              right: Utils.getDeviceWidth(context) / 30,
                              top: 15),
                          padding: EdgeInsets.only(top: 0),
                          child: MaterialButton(
                            color: ColorRes.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              StringRes.yes,
                              style: TextStyle(color: ColorRes.white),
                            ),
                            onPressed: () {
                              deleteBusinessApi();
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //api

  deleteBusinessApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });
      WebApi()
          .callAPI(Const.delete, WebApi.rqBusiness, null, Injector.accessToken)
          .then((data) async {
        print(data);
        print("delete business account");
        await Injector.prefs.clear();
        Injector.accessToken = null;
        _handleSignOut();
        Utils.showToast(StringRes.deleteSuccessMsg);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MainLoginPage()),
          ModalRoute.withName('/login'),
        );
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MainLoginPage()),
          ModalRoute.withName('/login'),
        );
      });
    }
  }

  profilePublicPrivate(int value) async {
    print("profile public private");

    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.get, "${WebApi.rqBusiness}/$value", null,
              Injector.accessToken)
          .then((data) async {
        setState(() {
          isLoading = false;
        });

        Utils.showToast(
            value == 0 ? StringRes.makePublic : StringRes.makePrivate);
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  var arrDay = [
    StringRes.monday,
    StringRes.tuesday,
    StringRes.wednesday,
    StringRes.thursday,
    StringRes.friday,
    StringRes.saturday,
    StringRes.sunday,
  ];

  getBusinessTypeList() {
    BusinessTypeModel businessTypeModel = new BusinessTypeModel();
    businessTypeModel.isSelectedType = false;
    businessTypeModel.businessTypes = StringRes.manufacturer;
    businessTypeModel.businessTypesInInt = 1;
    businessTypeList.add(businessTypeModel);

    BusinessTypeModel businessTypeModel2 = new BusinessTypeModel();
    businessTypeModel2.isSelectedType = false;
    businessTypeModel2.businessTypes = StringRes.wholeSeller;
    businessTypeModel2.businessTypesInInt = 2;
    businessTypeList.add(businessTypeModel2);

    BusinessTypeModel businessTypeModel3 = new BusinessTypeModel();
    businessTypeModel3.isSelectedType = false;
    businessTypeModel3.businessTypes = StringRes.retailer;
    businessTypeModel3.businessTypesInInt = 3;
    businessTypeList.add(businessTypeModel3);
  }

  getBusinessUserData() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });
      WebApi().callAPI(Const.get, WebApi.rqBusinessMe, null, Injector.accessToken).then((data) async {
        if (data.success) {
          UserBusinessData userBusinessData = UserBusinessData.fromJson(data.data);

          businessNameTF.text = userBusinessData.businessName;
          businessAddressTF.text = userBusinessData.address;
          mobileTF.text = userBusinessData.phone;
          telephoneTF.text = userBusinessData.telephone;
          makeProfileCheck = userBusinessData.isPrivate;
          otherInfoTF.text = userBusinessData.otherInfo;

          Injector.prefs
              .setString(PrefKeys.businessName, userBusinessData.businessName);
          Injector.prefs
              .setString(PrefKeys.businessAddress, userBusinessData.address);
//          _notifier.notify(PrefKeys.businessName, userBusinessData.businessName);

          Injector.streamController.add(StringRes.sideImage);

          for (int i = 0; i < dayTimeList.length; i++) {
            for (int j = 0; j < userBusinessData.time.length; j++) {
              if (checkDay[i] == userBusinessData.time[j].day) {
                dayTimeList[i].startTime = userBusinessData.time[j].startTime;
                dayTimeList[i].endTime = userBusinessData.time[j].endTime;
                dayTimeList[i].isCheck = true;
                break;
              }
            }
          }

          //show business type.
          if (userBusinessData.categories != null) {
            categoryList = userBusinessData.categories.split(',');
          }

          businessTypeDisplayList = userBusinessData.businessType;

          for (int i = 0; i < businessTypeDisplayList.length; i++) {
            for (int j = 0; j < businessTypeList.length; j++) {
              if (businessTypeDisplayList[i] ==
                  businessTypeList[j].businessTypesInInt) {
                businessTypeList[j].isSelectedType = true;
                break;
              }
            }
          }
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      }).catchError((e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  updateBusinessProfile() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      BusinessCreateRequest rq = BusinessCreateRequest();

      List<int> businessTypeArray = [];
      for (int i = 0; i < businessTypeList.length; i++) {
        if (businessTypeList[i].isSelectedType) {
          businessTypeArray.add(businessTypeList[i].businessTypesInInt);
        }
      }

      String categoryTOString = categoryList.join(',');

      String lat = Injector.prefs.get(PrefKeys.latitude);
      String log = Injector.prefs.get(PrefKeys.longitude);

      selectDayList = dayTimeList.where((test) => test.isCheck).toList();
      rq.business_name = businessNameTF.text;
      rq.address = businessAddressTF.text;
      rq.phone = mobileTF.text;
      rq.telephone = telephoneTF.text;
      rq.categories = categoryTOString;
      rq.other_info = otherInfoTF.text;
      rq.business_type = businessTypeArray;
      rq.latitude = lat;
      rq.longitude = log;
      rq.time = selectDayList;

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.rqBusiness, rq.toJson(),
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse != null && baseResponse.success) {
          Utils.showToast(StringRes.updateBusinessProMsg);
          getBusinessUserData();
          setState(() {
            editBusinessInfo = !editBusinessInfo;
            isLoading = false;
          });
          Injector.streamController.add(StringRes.sideImage);
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

class Day {
  String name;
  bool isCheck;

  Day({this.name, this.isCheck});
}

class BusinessType {
  String name;
  bool isCheck;

  BusinessType({this.name, this.isCheck});
}
