import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/mapLib/flutter_google_places.dart';
import 'package:marketplace/model/business_type_model.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:marketplace/model/create_profile.dart';
import 'package:marketplace/model/send_otp.dart';
import 'dart:io' show Platform;

import '../helper/res.dart';
import '../helper/utils.dart';
import 'login_verify_page.dart';

import 'package:geocoder/geocoder.dart';

class CreateProfile extends StatefulWidget {
  final UserData userData;

  const CreateProfile({Key key, this.userData}) : super(key: key);

  @override
  _BusinessPageState createState() => _BusinessPageState();
}

class _BusinessPageState extends State<CreateProfile> {
  bool editBusinessInfo = true;
  bool checkBoxTime = false;

  bool manufacturer = false;
  bool wholeSeller = false;
  bool retailer = false;

  bool isLoading = false;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  List<BusinessTypeModel> businessTypeList = new List<BusinessTypeModel>();
  bool isForBusiness = false;
  bool isForBusinessAddress = false;
  bool isForMobileNumber = false;
  bool isForMobileNumber10Limit = false;
  bool isForTelephoneNumber = false;
  bool isForOtherInfo = false;
  bool isCategoryEmpty = false;

  final _formKey = GlobalKey<FormState>();
  final _formKeyForCategory = GlobalKey<FormState>();
  List<String> categoryList = new List<String>();

  String categoryTOString;

  bool isSelectBusinessType = false;
  bool isSelectDateTime = false;
  bool isSelectTimeInvalid = false;

  bool isForBusinessTypeNull = false;

  String latitude;
  String longitude;

  FocusNode otherInfoTFNode = new FocusNode();

  TextEditingController businessNameTF = TextEditingController();
  TextEditingController businessAddressTF = TextEditingController();
  TextEditingController mobileTF = TextEditingController();
  TextEditingController telephoneTF = TextEditingController();
  TextEditingController businessCatTF = TextEditingController();
  TextEditingController otherInfoTF = TextEditingController();
  TextEditingController categoryTF = TextEditingController();
  bool isForCategory = false;
  List<int> businessTypeArray = [];

  final FocusNode mobile = FocusNode();
  final FocusNode telephone = FocusNode();

  bool _isBlockedSpaceKey = false;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: StringRes.googleAddress);

  List<Time> dayTimeList = [
    Time(
        day: StringRes.monday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
    Time(
        day: StringRes.tuesday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
    Time(
        day: StringRes.wednesday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
    Time(
        day: StringRes.thursday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
    Time(
        day: StringRes.friday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
    Time(
        day: StringRes.saturday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
    Time(
        day: StringRes.sunday,
        isCheck: false,
        startTime: "08:00",
        endTime: "22:00"),
  ];

  List selectDayList;

  @override
  void initState() {
    super.initState();
    getBusinessTypeList();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    otherInfoTFNode.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text("Create New Profile", style: TextStyle(fontSize: Utils.getDeviceWidth(context)/21)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    titleText(StringRes.businessName, 1),
                    nameTextFiled(),
                    titleText(StringRes.businessAddress, 2),
                    addressTextFiled(),
                    titleTextMobileNumber(),
                    mobileNumberView(),
                    titleText(StringRes.telephoneNumber, 4),
                    telephoneNumberView(),
                    titleText(StringRes.openingTime, 5),
                    dateTimeView(),
                    dateTimeValidation(),
                    invalidTime(),
                    titleText(StringRes.businessCategory, 6),
                    busDesTitleText(StringRes.businessDes),
                    categoryTextFiled(),
                    addCategory(),
                    selectedCategoryList(),
                    titleText(StringRes.businessType, 7),
                    businessType(),
                    titleText(StringRes.otherInfoCustomer, 8),
                    noReturnTextFiled(),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    createProBtn(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 0,
            color: ColorRes.transparent,
          )
        ],
      ),
    );
  }

  Widget addCategory() {
    return InkResponse(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10, top: 15),
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
          if (categoryTF.text.isNotEmpty &&
              categoryTF.text.toString() != null &&
              categoryTF.text.toString().trim() != null &&
              categoryTF.text.toString().trim().isNotEmpty) {
            categoryList.add(categoryTF.text.toString());
            categoryTF.text = "";
            setState(() {});
          }
        }
      },
    );
  }

  nameTextFiled() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 200,
          right: Utils.getDeviceWidth(context) / 30,
          left: Utils.getDeviceWidth(context) / 30),
      //padding: EdgeInsets.only(right: 10, left: 10, top: 5),
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
//                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
                cursorColor: ColorRes.black,
                controller: businessNameTF,
                enabled: editBusinessInfo,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  fillColor: ColorRes.white,
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
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

  titleTextMobileNumber() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: Utils.getDeviceWidth(context) / 25,
          top: Utils.getDeviceHeight(context) / 50,
          bottom: Utils.getDeviceHeight(context) / 120),
      child: Text("Mobile Number* (OTP Verification Required)",
          style: TextStyle(
              fontSize: Utils.getDeviceHeight(context) / 60,
              fontWeight: FontWeight.w700)),
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
        longitude = addresses.first.coordinates.longitude.toString();

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  addressTextFiled() {
    Prediction p;

    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 200,
          right: Utils.getDeviceWidth(context) / 30,
          left: Utils.getDeviceWidth(context) / 30),
      //padding: EdgeInsets.only(right: 10, left: 10, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: InkResponse(
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 15, left: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: ColorRes.white,
                    border: Border.all(color: ColorRes.black, width: 1)),
                child: Text(
                    businessAddressTF == null ? "" : businessAddressTF.text,
                    style: TextStyle(color: ColorRes.black, fontSize: Utils.getDeviceWidth(context)/26)),
              ),
              onTap: () async {
                p = await PlacesAutocomplete.show(
                    context: context,
                    mode: Mode.overlay,
                    apiKey: StringRes.googleAddress);
                displayPrediction(p);

                setState(() {});
              },
            ),
          ),
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
    );
  }

  mobileNumberView() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 200,
          right: Utils.getDeviceWidth(context) / 30,
          left: Utils.getDeviceWidth(context) / 30),
      //padding: const EdgeInsets.only(left: 8.0, right: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 0, left: 0, bottom: 5),
            child: Image.asset(
              Utils.getAssetsImg("phone"),
              height: Utils.getDeviceHeight(context) / 25,
              width: Utils.getDeviceHeight(context) / 25,
            ),
          ),
          /*Container(
            margin: const EdgeInsets.only(right: 0, left: 0, bottom: 5),
            child: Text(
              StringRes.nineOne,
              style: TextStyle(fontSize: Utils.getDeviceHeight(context) / 50),
            ),
          ),*/
          Container(
            child: phoneNumberAddText(),
            width: Utils.getDeviceWidth(context) * 2 / 5,
            margin: EdgeInsets.only(
                top: Utils.getDeviceHeight(context) / 150,
                left: 5),
          ),
        ],
      ),
    );
  }

  telephoneNumberView() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 200,
          right: Utils.getDeviceWidth(context) / 30,
          left: Utils.getDeviceWidth(context) / 65),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 10, left: 15),
              child: Image(
                  height: Utils.getDeviceHeight(context) / 30,
                  width: Utils.getDeviceHeight(context) / 30,
                  image: AssetImage(Utils.getAssetsImg("telephone")))),
          Container(
            width: Utils.getDeviceWidth(context) * 2 / 5,
            margin: EdgeInsets.only(left: 5),
            child: telePhoneNumberAddText(),
          ),
        ],
      ),
    );
  }

  dateTimeView() {
    return Container(
        child: ListView.builder(
            itemCount: dayTimeList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  allDayList(index),
                  dayTimeList[index].isCheck
                      ? Row(
                          children: <Widget>[
                            startTime(index),
                            Container(
                              child: Text(" - "),
                            ),
                            endTime(index)
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              height: 25,
                              padding: EdgeInsets.only(right: 35),
                              margin: EdgeInsets.only(right: 0, top: 0),
                              child: Text(
                                StringRes.closed,
                                style: TextStyle(
                                    color: ColorRes.overallGreyText,
                                    fontSize:
                                        Utils.getDeviceWidth(context) / 28),
                              ),
                            ),
                          ],
                        )
                ],
              );
            }));
  }

  dateTimeValidation() {
    return Visibility(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
            left: Utils.getDeviceWidth(context) / 25,
            top: Utils.getDeviceHeight(context) / 100),
        child: Text(StringRes.requiredFiled,
          style:
              Theme.of(context).textTheme.caption.copyWith(color: ColorRes.red),
        ),
      ),
      visible: isSelectDateTime,
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

  Widget categoryTextFiled() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            top: Utils.getDeviceHeight(context) / 200,
            right: Utils.getDeviceWidth(context) / 30,
            left: Utils.getDeviceWidth(context) / 30),
        //padding: const EdgeInsets.only(top: 5.0, right: 10, left: 10),
        child: Form(
          key: _formKeyForCategory,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: Utils.getDeviceHeight(context) / 15,
                color: ColorRes.white,
                child: Theme(
                  data: ThemeData(primaryColor: ColorRes.black),
                  child: TextFormField(
                    cursorColor: ColorRes.black,
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
                      hintStyle: TextStyle(color: ColorRes.greyText, fontFamily: FontRes.nunito, fontWeight: FontWeight.normal, fontSize: Utils.getDeviceWidth(context)/28),
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
                            .copyWith(color: ColorRes.red),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
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
                    top: 5.0, left: 12.0, bottom: 10.0, right: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text(categoryList[index], style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),)),
                    InkResponse(
                      child: Icon(Icons.delete_outline),
                      onTap: () {
                        confirmationDialog(index);
                      },
                    ),
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

  businessType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.fromLTRB(
              Utils.getDeviceWidth(context) / 25, 0, 10, 10),
          children: List.generate(businessTypeList.length, (index) {
            return Padding(
              padding: EdgeInsets.only(top: Utils.getDeviceWidth(context) / 50),
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
                    style:
                        TextStyle(fontSize: Utils.getDeviceWidth(context) / 30),
                  ))
                ],
              ),
            );
          }),
        ),
        isForBusinessTypeNull
            ? Padding(
                padding: EdgeInsets.only(
                    left: Utils.getDeviceWidth(context) / 25,
                    top: 0,
                    bottom: 0),
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
      //padding: EdgeInsets.only(top: 5.0, left: 10, bottom: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: Container(
              color: ColorRes.white,
              child: TextFormField(
                cursorColor: ColorRes.black,
                controller: otherInfoTF,
                focusNode: otherInfoTFNode,

                enabled: editBusinessInfo,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 28),
//                  textInputAction: TextInputAction.go,

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
          isForOtherInfo
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

  allDayList(int index) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(Utils.getDeviceWidth(context) / 25,
              Utils.getDeviceHeight(context) / 60, 0, 0),
          child: InkResponse(
            child: Image(
                height: Utils.getDeviceHeight(context) / 30,
                width: Utils.getDeviceHeight(context) / 30,
                image: editBusinessInfo == true
                    ? AssetImage(Utils.getAssetsImg(dayTimeList[index].isCheck
                        ? "checked_img"
                        : "unchecked_img"))
                    : AssetImage("")),
            onTap: () {
              setState(() {
                dayTimeList[index].isCheck = !dayTimeList[index].isCheck;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8, left: 7),
          child: Text(
            dayTimeList[index].day,
            style: TextStyle(
                fontSize: Utils.getDeviceWidth(context) / 28,
                color: !dayTimeList[index].isCheck
                    ? ColorRes.greyText
                    : ColorRes.black),
          ),
        )
      ],
    );
  }

  startTime(int index) {
    var newTime;

    return InkResponse(
      child: Container(
        //height: Utils.getDeviceHeight(context) / 30,
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(right: 0, top: 5),
        decoration: editBusinessInfo == true
            ? BoxDecoration(
                border: Border.all(color: ColorRes.rateBoxBorder, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              )
            : BoxDecoration(),
        child: Text(dayTimeList[index].startTime ?? "08:45",
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: Utils.getDeviceWidth(context) / 28)),
      ),
      onTap: () {
        DatePicker.showTimePicker(context,
            showTitleActions: true,
            showSecondsColumn: false, onChanged: (date) {
          var startTime = date.toString();
          newTime = startTime.substring(11, 16);
          print(newTime);
        }, onConfirm: (date)
            {
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
    );
  }

  endTime(int index) {
    var newTime;

    return InkResponse(
      child: Container(
        //height: Utils.getDeviceHeight(context) / 30,
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(right: 10, top: 5),
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
              fontSize: Utils.getDeviceWidth(context) / 28),
        ),
      ),
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
    );
  }

  Widget titleText(String title, int type) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: Utils.getDeviceWidth(context) / 25,
          top: Utils.getDeviceHeight(context) / 50,
          bottom: Utils.getDeviceHeight(context) / 120),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: Utils.getDeviceHeight(context) / 60,
                fontWeight: FontWeight.w700),
          ),
          type == 4 || type == 8
              ? Text("")
              : Text(
                  "*",
                  style: TextStyle(
                      fontSize: Utils.getDeviceHeight(context) / 50,
                      fontWeight: FontWeight.w600),
                ),
        ],
      ),
    );
  }

  busDesTitleText(String title) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: Utils.getDeviceWidth(context) / 25,
          bottom: Utils.getDeviceHeight(context) / 50,
          right: Utils.getDeviceWidth(context) / 25),
      child: Text(
        title,
        style: TextStyle(
            height: Platform.isAndroid? 1.1 : 1.3,
            color: ColorRes.lightGrey,
            fontSize: Utils.getDeviceHeight(context) / 60),
        textAlign: TextAlign.justify,
      ),
    );
  }

  editDeleteText(String stringName, int type) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
      child: InkResponse(
        child: Text(stringName,
            style: type == 1
                ? TextStyle(color: ColorRes.lightBlueText)
                : TextStyle(color: ColorRes.lightRedText)),
        onTap: () {
          setState(() {
//              editBusinessInfo != editBusinessInfo;
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
      child: Text(
        text,
        style: TextStyle(color: ColorRes.greyText),
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
            height: Utils.getDeviceHeight(context) / 19,
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
            height: Utils.getDeviceHeight(context) / 19,
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

  createProBtn() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
      height: Utils.getDeviceHeight(context) / 13,
      width: Utils.getDeviceWidth(context),
      color: ColorRes.black,
      child: MaterialButton(
          child: Text(
            StringRes.createProfile,
            style: TextStyle(
                color: ColorRes.white,
                fontSize: Utils.getDeviceHeight(context) / 42),
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
              if (!isForCategory &&
                  !isSelectDateTime &&
                  !isSelectTimeInvalid &&
                  !isForBusinessTypeNull) {
                if (mobileTF.text.length == 10 && isSelectDateTime == false) {
                  otpSendApi();
                }
              }
            }
          }),
    );
  }

  //api mobile verify

  otpSendApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      SendOtpRequest rq = SendOtpRequest();
      rq.phone = mobileTF.text;
      rq.countryCode = StringRes.sendNineOne;

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.sendOtp, rq.toJson(),
              widget.userData.auth.accessToken)
          .then((baseResponse) async {
        if (baseResponse != null && baseResponse.success) {
          Utils.showToast(baseResponse.message);

          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            BusinessCreateRequest rq = BusinessCreateRequest();

            selectDayList = dayTimeList.where((test) => test.isCheck).toList();

            String categoryTOString = categoryList.join(',');

            List<int> businessTypeArray = [];
            for (int i = 0; i < businessTypeList.length; i++) {
              if (businessTypeList[i].isSelectedType) {
                businessTypeArray.add(businessTypeList[i].businessTypesInInt);
              }
            }

            rq.business_name = businessNameTF.text;
            rq.address = businessAddressTF.text;
            rq.phone = mobileTF.text;
            rq.telephone = telephoneTF.text;
            rq.categories = categoryTOString;
            rq.other_info = otherInfoTF.text;
            rq.business_type = businessTypeArray;
            rq.latitude = latitude;
            rq.longitude = longitude;
            rq.time = selectDayList;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginVerifyPage(
                        businessCreateRequest: rq,
                        mobile: mobileTF.text,
                        userData: widget.userData)));
          }
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

class BusinessTypes {
  String name;
  bool isCheck;

  BusinessTypes({this.name, this.isCheck});
}
