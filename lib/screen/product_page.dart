import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:marketplace/commonview/MyBehavior.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/AnalyticsModel.dart';
import 'package:marketplace/model/addcategory.dart';
import 'package:marketplace/model/getProductData.dart';
import 'package:marketplace/model/getcategory.dart';
import 'package:marketplace/model/signin.dart';
import 'package:marketplace/screen/product_Info_page.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>{
  TextEditingController addCategoryController = TextEditingController();
  TextEditingController editCategoryController = TextEditingController();

  List<bool> numberTruthList = [true, true, true, true, true, true];

  List<GetCategoryAndProduct> arrCategoryAndProduct = List();
  ScrollController _hideButtonController;
  bool isLoading = true;

  Meta meta = Meta();

  bool _isVisible = false;
  int page = 1;

  double valueWidth = 0;
  final dataKey = new GlobalKey();

  bool fabIsVisible = true;
  ScrollController controller = ScrollController();
  
  @override
  void initState() {
      
    Injector.streamController = StreamController.broadcast();

    controller.addListener(() { 
      setState(() {
        fabIsVisible =controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });

    Injector.streamController.stream.listen((data) {
      if (data == StringRes.subProductDataGet) {
        setState(() {
          arrCategoryAndProduct = List();
          page = 1;
          getProductList(page); //n
        });
      }
    }, onDone: () {}, onError: (error) {});
    getProductList(null);

     super.initState();
  }

  List<int> data = [];
  int currentLength = 0;
  bool isLoadingLazy = false;
  final int increment = 10;

  Future _loadMore() async {
    if (mounted) {
      setState(() {
        isLoadingLazy = true;
      });
    }

    await new Future.delayed(const Duration(seconds: 5));
    if (meta.currentPage == page) {
      page++;
      getProductList(page);
    }
    if (mounted) {
      setState(() {
        isLoadingLazy = false;
      });
    }
  }

  indicatorShow() {
    return Container(
      height: isLoadingLazy ? 50.0 : 0.0,
      margin: EdgeInsets.only(top: 10.0),
      color: ColorRes.productBgGrey,
      child: Center(
        child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(ColorRes.black)),
      ),
    );
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
                color: ColorRes.black, size: Utils.getDeviceWidth(context) / 20)
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorRes.productBgGrey,
      body: Container(
        color: ColorRes.productBgGrey,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            primary: true,
            child: new Column(
              children: <Widget>[
                firstAddCategory(),
                addProductIcon(),
                noProducts(),
                addProductsHere(),
                secondListData(),
                indicatorShow(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: arrCategoryAndProduct.length > 1
          ? Container(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              margin: EdgeInsets.only(left: 0, right: 0),
              width: Utils.getDeviceWidth(context) / 3,
              child: Visibility(
                visible: _isVisible,
                child: MaterialButton(
                  color: ColorRes.black,
                  onPressed: () => {
                   Scrollable.ensureVisible(dataKey.currentContext),
                      // _animateToIndex(Const.categoryIndexToScroll)
                    //_scrollToIndex()
                   // _scrollController.scrollTo(index:Const.categoryIndexToScroll, duration: Duration(seconds: 1))
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //_animateToIndex(i) => controller.animateTo(150 * i, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);

  firstAddCategory() {
    return InkWell(
      key: dataKey,
      child: Align(
        alignment: Alignment.center,
        child: Container(
            margin: EdgeInsets.only(
                top: Utils.getDeviceHeight(context) / 45, bottom: 0),
            child: Card(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  color: ColorRes.black,
                  child: Text(
                    "ADD NEW PRODUCT CATEGORY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorRes.white,
                        fontSize: Utils.getDeviceWidth(context) / 28,
                        fontWeight: FontWeight.w600),
                  ),
                ))),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return customDialog(StringRes.addCategoryName, 1, -1);
            });
      },
    );
  }

  addProductIcon() {
    return arrCategoryAndProduct.length > 0
        ? Container()
        : Container(
            height: Utils.getDeviceWidth(context) / 5,
            //width:  Utils.getDeviceWidth(context)/6,
            margin: EdgeInsets.only(
                right: 0, left: 0, top: Utils.getDeviceHeight(context) / 11),
            alignment: Alignment(0, 0),
            child: Image.asset(
              Utils.getAssetsImg("sale"),
              height: Utils.getDeviceHeight(context) / 2,
              width: Utils.getDeviceWidth(context) / 2,
            ),
          );
  }

  noProducts() {
    return arrCategoryAndProduct.length > 0
        ? Container()
        : Container(
            //height: Utils.getDeviceHeight(context)/20,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(
                right: 0, left: 0, top: Utils.getDeviceWidth(context) / 60),
            padding: EdgeInsets.only(
                left: Utils.getDeviceWidth(context) / 24,
                right: Utils.getDeviceWidth(context) / 24),
            alignment: Alignment(0, 0),
            child: Text("You don't have any products yet.",
                style: TextStyle(
                    color: ColorRes.cancelGreyText,
                    fontSize: Platform.isAndroid
                        ? Utils.getDeviceWidth(context) / 22
                        : Utils.getDeviceWidth(context) / 23,
                    fontFamily: FontRes.nunito),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          );
  }

  addProductsHere() {
    return arrCategoryAndProduct.length > 0
        ? Container()
        : Container(
            //height: Utils.getDeviceHeight(context)/20,
            //width:  Utils.getDeviceWidth(context),
            margin: EdgeInsets.only(
                right: 0, left: 0, top: Utils.getDeviceHeight(context) / 60),
            padding: EdgeInsets.only(
                left: Utils.getDeviceWidth(context) / 22,
                right: Utils.getDeviceWidth(context) / 24),
            alignment: Alignment(0, 0),
            child: Text("Upload your products here",
                style: TextStyle(
                    color: ColorRes.cancelGreyText,
                    fontSize: Platform.isAndroid
                        ? Utils.getDeviceWidth(context) / 22
                        : Utils.getDeviceWidth(context) / 23,
                    fontFamily: FontRes.nunito),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          );
  }

  Widget secondListData() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrCategoryAndProduct.length,
      controller: controller,
      itemBuilder: (context, categoryIndex) {
        return showMainCategoryItem(categoryIndex);
      },
    );

    // return ScrollablePositionedList.builder(
    //     itemScrollController: _scrollController,
    //     itemCount: arrCategoryAndProduct.length,
    //     itemBuilder: (context, categoryIndex) {
    //         return showMainCategoryItem(categoryIndex);
    //        });

  }

  showMainCategoryItem(int categoryIndex) {
    return ListView(
      shrinkWrap: true,
      primary: false,
     // key: ObjectKey(arrCategoryAndProduct[Const.categoryIndexToScroll]),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 8.0),
          color: ColorRes.productBgGrey,
          child: Row(
            children: <Widget>[
              Text(
                StringRes.categoryName,
                style: TextStyle(
                    fontSize: Utils.getDeviceWidth(context) / 27,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                  child: Text(
                arrCategoryAndProduct[categoryIndex].category.toUpperCase(),
                style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 27),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              rightSidePopUp(categoryIndex),
            ],
          ),
        ),
        Container(
          height: Utils.getDeviceWidth(context) / 1.8,
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              cacheExtent: 1500,
              primary: false,
              itemCount:
                  arrCategoryAndProduct[categoryIndex].products.length + 1,
              scrollDirection: Axis.horizontal,
             // key: ObjectKey(arrCategoryAndProduct[Const.categoryIndexToScroll].products[Const.productIndexToScroll]),
              padding: EdgeInsets.all(0),
              itemBuilder: (context, productIndex) {
                if (productIndex >=
                    arrCategoryAndProduct[categoryIndex].products.length)
                  return addProductCard(context, categoryIndex);
                else {
                  return showProductItem(
                      productIndex,
                      arrCategoryAndProduct[categoryIndex]
                          .products[productIndex],
                      categoryIndex);
                }
              }),
        )
      ],
    );
  }

  Widget addProductCard(BuildContext context, int categoryIndex) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4,
          child: Container(
            width: Utils.getDeviceWidth(context) / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(Utils.getAssetsImg("plus_black"),
                    height: Utils.getDeviceWidth(context) / 17,
                    width: Utils.getDeviceWidth(context) / 17),
                Text(
                  StringRes.addProduct,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, height: 1.05),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        onClickAddCard(context, categoryIndex);
      },
    );
  }

  void getDataFromEdit(Product detailClass, int cat_id) {
    for (int i = 0; i < arrCategoryAndProduct.length; i++) {
      if (arrCategoryAndProduct[i].id == cat_id) {
        arrCategoryAndProduct[i].products.add(detailClass);
        setState(() {});
      }
    }
  }

  Future onClickAddCard(BuildContext context, int categoryIndex) async {
    int cat_id = arrCategoryAndProduct[categoryIndex]?.id;
    final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductInfoPage(
                    categoryId: arrCategoryAndProduct[categoryIndex]?.id)))
        .then((val) {
      if (val != null) {
        getDataFromEdit(val, cat_id);
      }
    });

    // if (isUpdated) {
    //   arrCategoryAndProduct = List();
    //   page = 1;
    //   ProductListUpdate(page); //n

    //   setState(() {});
    // }
  }

  showProductItem(int productIndex, Product product, int categoryIndex) {
    return InkResponse(
      child: Container(
          width: Utils.getDeviceWidth(context) / 2.3,
          padding: EdgeInsets.all(4.0),
          child: Stack(children: <Widget>[
            Card(
                color: ColorRes.white,
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      color: ColorRes.white,
                      padding: EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                        child: product.photo != null &&
                                product.photo.isNotEmpty &&
                                product.photo.contains("http")
                            ? CachedNetworkImage(
                                imageUrl: "https://images.weserv.nl/?url=" +
                                    product.photo +
                                    "&w=300&h=300",
                                width: double.infinity,
                                height: Utils.getDeviceWidth(context) / 3.2,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                    Utils.getAssetsImg("product_default"),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        Utils.getAssetsImg("product_default"),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover),
                              )
                            : Image.asset(Utils.getAssetsImg("product_default"),
                                width: double.infinity,
                                height: Utils.getDeviceHeight(context) / 5.7,
                                fit: BoxFit.cover),
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 3, top: 5),
                      child: Text(
                        product.productName.toUpperCase(),
                        style: TextStyle(
                            fontSize: Utils.getDeviceWidth(context) / 34),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 4),
                            child: Image(
                                height: Utils.getDeviceWidth(context) / 30,
                                width: Utils.getDeviceWidth(context) / 30,
                                image: AssetImage(Utils.getAssetsImg("rupee"))),
                          ),
                          Container(
                            child: Text(
                              "${product.price}",
                              style: TextStyle(
                                  fontSize: Utils.getDeviceWidth(context) / 34),
                            ),
                          )
                        ],
                      ),
                    ),
                    /*Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                  child: Text("${product.perQuantity}".toUpperCase(),
                      style: TextStyle(
                          fontSize: Utils.getDeviceWidth(context) / 34)),
                ),*/
                  ],
                )),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  shareLink(product);
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            )
          ])),
      onTap: () {
        Const.categoryIndexToScroll=categoryIndex;
        Const.productIndexToScroll=productIndex;
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

  Future<Size> _calculateImageDimension(String photo) {
    Completer<Size> completer = Completer();
    Image image = Image.network(photo);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  Future<void> navigateToProductInfo(int categoryIndex, Product product) async {
    bool isUpdated = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductInfoPage(
                  categoryId: arrCategoryAndProduct[categoryIndex]?.id,
                  productId: product != null ? product.id : null,
                )));

    if (isUpdated != null && isUpdated) {
      arrCategoryAndProduct = List();
      page = 1;
      getProductList(page); //n
      setState(() {});
    }
  }

  rightSidePopUp(int categoryIndex) {
    return PopupMenuButton<String>(
        onSelected: choiceAction,
        offset: Offset(100, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        itemBuilder: (BuildContext con) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice + "," + categoryIndex.toString(),
              height: Utils.getDeviceHeight(context) / 16,
              textStyle: Theme.of(context).textTheme.body2,
              child: InkResponse(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(choice),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  print(arrCategoryAndProduct[categoryIndex].id);

                  setState(() {});
                  if (choice == Constants.FirstItem) {
                    bool isUpdated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductInfoPage(
                                categoryId:
                                    arrCategoryAndProduct[categoryIndex].id)));
                    if (isUpdated) {
                      arrCategoryAndProduct = List();
                      page = 1;
                      getProductList(page); //n
                      setState(() {});
                    }
                  } else if (choice == Constants.SecondItem) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return customDialog(
                              StringRes.editCategoryName, 2, categoryIndex);
                        });
                  } else if (choice == Constants.ThirdItem) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return customDialog(
                              StringRes.deleteCategoryMsg, 3, categoryIndex);
                        });
                  }
                },
              ),
            );
          }).toList();
        });
  }

  choiceAction(String choiceAndCategoryIndex) async {
    var choice = choiceAndCategoryIndex.toString().split(",")[0];
    var categoryIndex =
        int.parse(choiceAndCategoryIndex.toString().split(",")[1]);

    if (choice == Constants.FirstItem) {
      bool isUpdated = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductInfoPage()));
      if (isUpdated) {
        arrCategoryAndProduct = List();
        page = 1;
        getProductList(page); //n
        setState(() {});
      }
    } else if (choice == Constants.SecondItem) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return customDialog(StringRes.editCategoryName, 2, categoryIndex);
          });
    } else if (choice == Constants.ThirdItem) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return customDialog(StringRes.deleteCategoryMsg, 3, categoryIndex);
          });
    }
  }

  customDialog(String hintText, int i, int categoryIndex) {
    if (i == 2) {
      editCategoryController.text =
          arrCategoryAndProduct[categoryIndex].category;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: i == 3
            ? ((Utils.getDeviceHeight(context) / 10) +
                20 +
                20 +
                10 +
                Utils.getDeviceHeight(context) / 20)
            : ((Utils.getDeviceHeight(context) / 20) +
                20 +
                20 +
                10 +
                10 +
                45 +
                Utils.getDeviceHeight(context) / 20), //125 : 160,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: i == 3
                    ? Utils.getDeviceHeight(context) / 10
                    : Utils.getDeviceHeight(context) / 20,
                //height: i == 3 ? 50 : 40,
                child: Text(
                  hintText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: Platform.isAndroid ? 1.1 : 1.4,
                      fontWeight: FontWeight.w500,
                      fontSize: Utils.getDeviceWidth(context) / 25),
                ),
              ),
              i == 3
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 45,
                      child: Theme(
                        data: ThemeData(primaryColor: ColorRes.black),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: Utils.getDeviceWidth(context) / 26),
                          cursorColor: ColorRes.black,
                          controller: i == 1
                              ? addCategoryController
                              : editCategoryController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(10),
                              hintText: ""),
                        ),
                      ),
                    ),
              Container(
                height: Utils.getDeviceHeight(context) / 20,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: ColorRes.productBgGrey)),
                        child: Text(
                          StringRes.cancel,
                          style: TextStyle(color: ColorRes.cancelGreyText),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: MaterialButton(
                        color: ColorRes.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          i == 3 ? StringRes.delete : StringRes.done,
                          style: TextStyle(color: ColorRes.white),
                        ),
                        onPressed: () {
                          if (i == 1) {
                            if (addCategoryController.text.isNotEmpty) {
                              Navigator.pop(context);
                              addCategoryApi();
                            } else {
                              Utils.showToast(StringRes.pleaseEnterCategory);
                            }
                          } else if (i == 2) {
                            Navigator.pop(context);
                            updateCategory(
                                arrCategoryAndProduct[categoryIndex].id);
                          } else if (i == 3) {
                            Navigator.pop(context);
                            deleteCategoryApi(
                                arrCategoryAndProduct[categoryIndex].id);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addCategoryApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);

      AddCategoryRequest rq = AddCategoryRequest();
      rq.category = addCategoryController.text;

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.rqCategory, rq.toJson(),
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          CommonView.progressDialog(false, context);
          Utils.showToast(StringRes.addCategorySuccess);
          addCategoryController.text = "";
          arrCategoryAndProduct = List();
          page = 1;
          getProductList(page); //n
        } else {
          CommonView.progressDialog(false, context);
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  getProductList(int index) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      WebApi()
          .callAPI(
              Const.get, "${WebApi.rqProductsList}", null, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          setState(() {
            isLoading = false;
            _isVisible = true;
            baseResponse.data.forEach((v) {
              arrCategoryAndProduct.add(GetCategoryAndProduct.fromJson(v));
//             GetCategoryAndProduct getCategoryAndProduct=GetCategoryAndProduct.fromJson(v);
//             for(int i=0;i<arrCategoryAndProduct.length;i++){
//  GetCategoryAndProduct addedItem=arrCategoryAndProduct[i];
//  List<Product> products=addedItem.products;
//           if(products.length<getCategoryAndProduct)

//             }
            });
            meta = baseResponse.meta;
            setState(() {

            });
          });
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            _isVisible = true;
          }
        }
      }).catchError((e) {
        print(e);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  ProductListUpdate(int index) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();
    List<GetCategoryAndProduct> arrCategoryAndProduct2 = new List();
    if (isConnected) {
      WebApi()
          .callAPI(Const.get, "${WebApi.rqProducts}${index.toString()}", null,
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          setState(() {
            isLoading = false;
            _isVisible = true;
            baseResponse.data.forEach((v) {
              arrCategoryAndProduct2.add(GetCategoryAndProduct.fromJson(v));
            });
            meta = baseResponse.meta;
            arrCategoryAndProduct = arrCategoryAndProduct2;
            setState(() {});
          });
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            _isVisible = true;
          }
        }
      }).catchError((e) {
        print(e);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  updateCategory(int categoryId) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);
      AddCategoryRequest rq = AddCategoryRequest();

      rq.category = editCategoryController.text;

      WebApi()
          .callAPI(Const.put, "${WebApi.rqCategory}/$categoryId", rq.toJson(),
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse != null && baseResponse.success) {
          CommonView.progressDialog(false, context);
          Utils.showToast(StringRes.updateCategorySuccess);
          arrCategoryAndProduct = List();
          page = 1;
          getProductList(page);
        } else {
          CommonView.progressDialog(false, context);
        }
      }).catchError((e) {
        print("login_" + e.toString());
        CommonView.progressDialog(false, context);
      });
    }
  }

  deleteCategoryApi(int categoryId) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);
      WebApi()
          .callAPI(Const.delete, "${WebApi.rqCategory}/$categoryId", null,
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse != null && baseResponse.success) {
          CommonView.progressDialog(false, context);
          Utils.showToast(StringRes.deleteCategorySuccess);
          arrCategoryAndProduct = List();
          page = 1;
          getProductList(page); //n

          setState(() {});
        } else {
          CommonView.progressDialog(false, context);
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
      });
    }
  }
}

class Constants {
  static const String FirstItem = 'Add product';
  static const String SecondItem = 'Edit category name';
  static const String ThirdItem = 'Delete category & products';
  int index;

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
  ];
}
