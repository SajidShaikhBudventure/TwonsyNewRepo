import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:marketplace/commonview/MyBehavior.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/AnalyticsModel.dart';
import 'package:marketplace/model/getProductData.dart';
import 'package:marketplace/model/getcategory.dart';
import 'package:marketplace/screen/product_Info_page.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:share/share.dart';



class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool isLoading = true;

  String selectedDateWithYear = "";

  Analytics analytics;
  List<ProductCategory> categories = List();

  bool _isVisible = false;
  GlobalKey analyticsKey = new GlobalKey();


  int currentPageName = 0;
  int page = 1;
 // Meta meta = Meta();
  bool fabIsVisible = true;
  ScrollController controller = ScrollController();

  @override
  void initState() {

    Injector.streamController = StreamController.broadcast();
    
    controller.addListener(() {
       fabIsVisible =controller.position.userScrollDirection == ScrollDirection.forward;
    });

    Injector.streamController.stream.listen((data) {
      if (data == StringRes.analyticalProductGet) {
        setState(() {
          categories = List();
           page = 1;
           Utils.isInternetConnected().then((isConnected) {
               if (isConnected) callApi();
          }); //n
        });
      }
    }, onDone: () {}, onError: (error) {});

     Utils.isInternetConnected().then((isConnected) {
      if (isConnected) callApi();
    });

    super.initState();
    
  }

  List<int> data = [];
  int currentLength = 0;
  bool isLoadingLazy = false;
  final int increment = 10;

  Future _loadMore() async {
   
  // if (mounted) {
      setState(() {
        isLoadingLazy = true;
      });
   // }

    await new Future.delayed(const Duration(seconds: 5));
    //if (meta.currentPage == page) {
      page++;
       Utils.isInternetConnected().then((isConnected) {
      if (isConnected) callApi();
       });
   // }
    //if (mounted) {
      setState(() {
        isLoadingLazy = false;
      });
    //}

  }


  indicatorShow() {
    return Container(
      height: isLoadingLazy ? 50.0 : 0.0,
      margin: EdgeInsets.only(top: 10.0),
      color: ColorRes.white,
      child: Center(
        child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(ColorRes.black)),
      ),);
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
    return widgetsLayout();
  }

  widgetsLayout() {
    return Scaffold(
     body:Container(
     // color: ColorRes.productBgGrey,
    child:ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        primary: true,
        // isLoading: isLoadingLazy,
         //onEndOfPage: () => _loadMore(),
         child: Column(
         // primary: true,
          //shrinkWrap: true,
          children: <Widget>[
            firstDropDownMenu(),
            titleTextShow("Your Business", 1),
            threePeopleView(),
            titleTextShow("Your Products", 2),
            noProducts(),
            fourMainListView(),
            SizedBox(
              height: 10,
            ),
            indicatorShow(),
          ],
        ),
      ),
    )),floatingActionButton: categories.length > 1
          ? Container(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              margin: EdgeInsets.only(left: 0, right: 0),
              width: Utils.getDeviceWidth(context) / 3,
              child: Visibility(
                visible: categories.length>1?true:false,
                child: MaterialButton(
                  color: ColorRes.black,
                  onPressed: () => {
                    Scrollable.ensureVisible(analyticsKey.currentContext),
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'GO TO TOP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Utils.getDeviceWidth(context) / 30),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2, left: 5),
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: Utils.getDeviceWidth(context) / 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,);
  }

  firstDropDownMenu() {
    return 
    Align(
      alignment: Alignment.centerRight,
      child: Container(
          key: analyticsKey,
          alignment: Alignment.center,
          width: Utils.getDeviceWidth(context) / 2.5,
          height: Utils.getDeviceHeight(context)/15,
          margin: EdgeInsets.only(right: 15.0, top: 15),
          padding: EdgeInsets.only(right: 5,left: 5, bottom: 5, top: 0),
          decoration: BoxDecoration(
            color: ColorRes.productBgGrey,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: ColorRes.productBgSubCat),
          ),
          child: InkResponse(
            onTap: () {
              getDateWithYear();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      selectedDateWithYear != null &&
                              selectedDateWithYear.isNotEmpty
                          ? selectedDateWithYear.toString()
                          : StringRes.monthSelection,
                      style: TextStyle(color: ColorRes.cancelGreyText,
                          fontSize: Utils.getDeviceWidth(context) / 21),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.keyboard_arrow_down, color: ColorRes.cancelGreyText),
                )
              ],
            ),
          )),
    );
  }

  getDateWithYear() {
    showMonthPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 1, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: DateTime.now())
        .then((date) {
      if (date != null) {
        var formatterForMonth = new DateFormat('MM');
        var formatterForYear = new DateFormat('yyyy');
        var formatterForDisplay = new DateFormat('MMM yyyy');
        String formatted = formatterForDisplay.format(date);
        selectedDateWithYear = formatted;
        if (formatterForMonth.format(date) != null &&
            formatterForYear.format(date) != null) {
          setState(() {
            isLoading = true;
          });
          callApiForGetAnalyticsInfo(formatterForMonth.format(date).toString(),
              int.parse(formatterForYear.format(date).toString()));
        }
      }
    });
  }

  secondOverAllText() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      width: Utils.getDeviceWidth(context) / 3.2,
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.rateBoxBorder, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(
        StringRes.overall,
        style: TextStyle(color: ColorRes.overallGreyText, fontSize: 20),
      ),
    );
  }

  titleTextShow(String title, int type) {
      return 
          Container(
        padding: EdgeInsets.only(bottom: 10, top: 15, left: 15, right: 8),
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(
              color: ColorRes.black, fontSize: Utils.getDeviceWidth(context)/19, fontWeight: FontWeight.w700),
        ),
      );
  }

  threePeopleView() {
    return Container(
      padding: EdgeInsets.all(Utils.getDeviceWidth(context) / 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: peopleShow(
                  analytics != null && analytics.businessView != null
                      ? analytics.businessView
                      : 0,
                  "Profile Views")),
          Expanded(
              flex: 3,
              child: peopleShow(
                  analytics != null && analytics.callCount != null
                      ? analytics.callCount
                      : 0,
                  "Phone Calls")),
          Expanded(
              flex: 3,
              child: peopleShow(
                  analytics != null && analytics.directionCount != null
                      ? analytics.directionCount
                      : 0,
                  "Location Views")),
        ],
      ),
    );
  }

  noProducts(){
    return categories.length>0
        ?Container()
        :Container(
      //height: Utils.getDeviceHeight(context)/20,
      //width:  Utils.getDeviceWidth(context),
      margin: EdgeInsets.only(right: 0, left:0, top: Utils. getDeviceWidth(context)/24),
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/24, right: Utils. getDeviceWidth(context)/24),
      alignment: Alignment(0,0),
      child: Text("No products yet", style: TextStyle(color: ColorRes.cancelGreyText, fontSize: Utils.getDeviceWidth(context)/20, fontFamily: FontRes.nunito), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  fourMainListView() {
    return 
    Container(
      child:ListView.builder(
      itemCount: categories.length,
       shrinkWrap: true,
       controller: controller,
       physics: ScrollPhysics(),
      //physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return listOfItem(index, categories[index]);
      },
    ));
  }

  listOfItem(int categoryIndex, ProductCategory productCategory) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: <Widget>[
        Container(
          height: 42,
          margin: EdgeInsets.only(top: 10, bottom: 10),
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
          color: ColorRes.productBgGrey,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  "${StringRes.categoryName}",
                  style:
                      TextStyle(fontSize: Utils.getDeviceWidth(context) / 27,
                          fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                  child: Text(
                productCategory.category.toUpperCase(),
                style: TextStyle(
                    fontSize: Utils.getDeviceWidth(context) / 27),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Padding(padding: EdgeInsets.only(right: 5))
            ],
          ),
        ),
        Container(
          height: Utils.getDeviceWidth(context) / 1.8,
          child: ListView.builder(
              itemCount: productCategory.products.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(5),
              itemBuilder: (context, index) {
                return listOfSubItem(
                    productCategory.products[index], categoryIndex);
              }),
        )
      ],
    );
  }

  listOfSubItem(Product product, int categoryIndex) {
    return InkResponse(
      child: Container(
        width: Utils.getDeviceWidth(context) / 2.3,
        padding: EdgeInsets.all(4.0),
        child:Stack( 
         children: <Widget>[
        
         Card(
            color: ColorRes.white,
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: ColorRes.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      child: product.photo != null &&
                              product.photo.isNotEmpty &&
                              product.photo.contains("http")
                          ? CachedNetworkImage(
                              imageUrl: product.photo,
                              width: double.infinity,
                              height: Utils.getDeviceWidth(context) / 3.2,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                  Utils.getAssetsImg("product_default"),
                                  width: double.infinity,
                                  height: Utils.getDeviceWidth(context) / 3.2,
                                  fit: BoxFit.cover),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Image.asset(Utils.getAssetsImg("product_default"),
                              width: double.infinity,
                              height: Utils.getDeviceHeight(context) / 5.7,
                              fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 3, top: 5),
                  child: Text(
                    product.productName.toUpperCase(),
                    style:
                        TextStyle(fontSize: Utils.getDeviceWidth(context) / 34),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Text(
                    "${product.views} ${StringRes.views}",
                    style:
                        TextStyle(fontSize: Utils.getDeviceWidth(context) / 34),
                  ),
                ),
              ],
            )),
             Positioned( 
           top: 0,
           right: 0,
           child: IconButton(
            onPressed: () {
              shareLink(product);
            },
            icon: Icon(Icons.share,color: Colors.black,size: 24,),
          ),)
         ])),
      onTap: () {
        navigateToProductInfo(categoryIndex, product);
      },
    );
  }

  void shareLink(Product product) {
    final RenderBox box = context.findRenderObject();
    Share.share("https://townsy.in/product/${product.id}",
        subject: "",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<void> navigateToProductInfo(int categoryIndex, Product product) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductInfoPage(
                  categoryId: categories[categoryIndex]?.id,
                  productId: product != null ? product.id : null,
                )));
           setState(() {});
  }

  
  Widget peopleShow(int view, String staticString) {
    double x= view/1000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          view<=10000?"$view":"$x"+"k",
          style: TextStyle(
              fontSize: Utils.getDeviceWidth(context) / 15),
        ),
        SizedBox(height: Utils.getDeviceHeight(context)/55),
        Text(
          staticString,
          maxLines: 2,
          style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 32, height: 0.95),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

//   callApiForGetAnalyticsInfo(String month, int year) async {
//     print("month: " + month + "====Year: " + year.toString());
    
//     //print("Token  "+Injector.accessToken);

//     bool isConnected = await Utils.isInternetConnectedWithAlert();
      
//     if (isConnected) {
//       Map<String, dynamic> map = {'month': month, 'year': year};
      
//       WebApi()
//           .callAPI(
//               Const.postWithAccess, page == 1 ? "/analytics_list" :"/analytics?page=${page.toString()}", map, Injector.accessToken)
//           .then((baseResponse) async {
//         if (baseResponse.success) {
//           setState(() {
//             isLoading = false;
//             _isVisible = true;
//          AnalyticsResponse analyticsResponse =
//               AnalyticsResponse.fromJson(baseResponse.data);

//           analytics = analyticsResponse.analytics;

// //          baseResponse.data.forEach((v) {
// //          });
//           for(int i = 0; i < analyticsResponse.categories.length; i++) {
// //            categories.add(baseResponse.data[i]);
// //            categories.add(ProductCategory.fromJson(baseResponse.data[i]));
//             categories.add(analyticsResponse.categories[i]);
//           }

//          // meta = baseResponse.meta as Meta;
//           setState(() {

//           });

//           });
//           }else {
//           if (mounted) {
//             setState(() {
//               isLoading = false;
//             });
//             _isVisible = true;
//           }
//         }
//       }).catchError((e) {
//         setState(() {
//           isLoading = false;
//         });
//         print("login_" + e.toString());
//       });
//     }

//   }

callApiForGetAnalyticsInfo(String month, int year) async {
    print("month: " + month + "====Year: " + year.toString());

    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      Map<String, dynamic> map = {'month': month, 'year': year};
      WebApi()
          .callAPI(
              Const.postWithAccess, page == 1 ? "/analytics_list" :"/analytics?page=${page.toString()}", map, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          AnalyticsResponse analyticsResponse =
              AnalyticsResponse.fromJson(baseResponse.data);

          analytics = analyticsResponse.analytics;

//          baseResponse.data.forEach((v) {
//          });


          for(int i = 0; i < analyticsResponse.categories.length; i++) {
//            categories.add(baseResponse.data[i]);
//            categories.add(ProductCategory.fromJson(baseResponse.data[i]));


            categories.add(analyticsResponse.categories[i]);


          }


//          categories = analyticsResponse.categories;
//          metaData = baseResponse.meta;

          setState(() {
            isLoading = false;
          });
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        print("login_" + e.toString());
      });
    }
  }

  Future callApi() {
    if (mounted) {
      var formatterForMonth = new DateFormat('MM');
      var formatterForYear = new DateFormat('yyyy');
      var formatterForDisplay = new DateFormat('MMM yyyy');

      String formatted = formatterForDisplay.format(DateTime.now());
      selectedDateWithYear = formatted;
      callApiForGetAnalyticsInfo(
          formatterForMonth.format(DateTime.now()).toString(),
          int.parse(formatterForYear.format(DateTime.now()).toString()),
      );
    }
  }
}

