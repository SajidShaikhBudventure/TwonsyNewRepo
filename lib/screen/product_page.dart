import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:marketplace/commonview/MyBehavior.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/addcategory.dart';
import 'package:marketplace/model/getProductData.dart';
import 'package:marketplace/model/signin.dart';
import 'package:marketplace/screen/product_Info_page.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController addCategoryController = TextEditingController();
  TextEditingController editCategoryController = TextEditingController();

  List<bool> numberTruthList = [true, true, true, true, true, true];

  List<GetCategoryAndProduct> arrCategoryAndProduct = List();

  bool isLoading = true;
  Meta meta = Meta();
  int page = 1;

  @override
  void initState() {
    super.initState();
    Injector.streamController = StreamController.broadcast();
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
          ));
    }
    return Container(
        color: ColorRes.productBgGrey,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: LazyLoadScrollView(
            isLoading: isLoading,
            onEndOfPage: () => _loadMore(),
            child: ListView(
              primary: true,
              shrinkWrap: true,
              children: <Widget>[
                firstAddCategory(),
                /*Container(
                    height: 0.9,
                    width: double.infinity,
                    color: ColorRes.lightGrey),*/
                secondListData(),
                indicatorShow(),
              ],
            ),
          ),
        ));
  }


  firstAddCategory() {
    return InkWell(
      child: Align(
        alignment: Alignment.center,
        child: Container(
            margin: EdgeInsets.only(top:Utils.getDeviceHeight(context) / 45, bottom: 0),
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
                ))),),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return customDialog(StringRes.addCategoryName, 1, -1);
            });
      },
    );
  }

  Widget secondListData() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: arrCategoryAndProduct.length,
      itemBuilder: (context, categoryIndex) {
        return showMainCategoryItem(categoryIndex);
      },
    );
  }

  showMainCategoryItem(int categoryIndex) {
    return ListView(
      shrinkWrap: true,
      primary: false,
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
              primary: false,
              itemCount:
              arrCategoryAndProduct[categoryIndex].products.length + 1,
              scrollDirection: Axis.horizontal,
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

  Future onClickAddCard(BuildContext context, int categoryIndex) async {
    bool isUpdated = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductInfoPage(
                categoryId: arrCategoryAndProduct[categoryIndex]?.id)));
    if (isUpdated) {
      arrCategoryAndProduct = List();
      page = 1;
      getProductList(page); //n

      setState(() {});
    }
  }

  showProductItem(int productIndex, Product product, int categoryIndex)   {

    return InkResponse(
      child: Container(
        width: Utils.getDeviceWidth(context) / 2.4,
        padding: EdgeInsets.all(4.0),
        child: Card(
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
                        placeholder: (context, url) =>
                            Image.asset(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Text(
                    product.productName.toUpperCase(),
                    style:
                    TextStyle(fontSize: Utils.getDeviceWidth(context) / 32),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 5),
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
                              fontSize: Utils.getDeviceWidth(context) / 32),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                  child: Text("${product.perQuantity}".toUpperCase(),
                      style: TextStyle(
                          fontSize: Utils.getDeviceWidth(context) / 32)),
                ),
              ],
            )),
      ),
      onTap: () {
        navigateToProductInfo(categoryIndex, product);
      },
    );
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
                  style: TextStyle(height: 1.05, fontWeight: FontWeight.w500, fontSize: Utils.getDeviceWidth(context)/27),
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
                    style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 26),
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
          .callAPI(Const.get, "${WebApi.rqProducts}${index.toString()}", null,
          Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          setState(() {
            isLoading = false;
            baseResponse.data.forEach((v) {
              arrCategoryAndProduct.add(GetCategoryAndProduct.fromJson(v));
            });
            meta = baseResponse.meta;
            setState(() {});
          });
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
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
