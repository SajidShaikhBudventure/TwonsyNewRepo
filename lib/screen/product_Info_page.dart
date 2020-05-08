import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/addproduct.dart';
import 'package:marketplace/model/getProductData.dart';
import 'package:shimmer/shimmer.dart';

class ProductInfoPage extends StatefulWidget {
  final int isAddProduct;
  final int categoryId;
  final int productId;

//  final Products product;

  const ProductInfoPage(
      {Key key, this.isAddProduct, this.categoryId, this.productId})
      : super(key: key);

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  bool isLoading = false;

  List<GetCategoryAndProduct> getCategoryAndProduct = List();

  TextEditingController productName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isForName = false;
  bool isForDescription = false;
  bool isForPrice = false;
  bool isForQuantity = false;

  Product product = Product();


  @override
  void initState() {
    super.initState();

    if (widget.productId != null) {
      getProductById(widget.productId);
    }
  }

  SwiperControl swiperControl = SwiperControl();
  SwiperPagination swiperPagination = SwiperPagination();
  int selectImageIndex = 0;
  List<ProductPhoto> arrImages = List();

  Future deleteImage(int photoId) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.delete, WebApi.rqDeleteImage + photoId.toString(),
              null, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          Injector.streamController?.add(StringRes.subProductDataGet);
//          _notifier.notify(StringRes.subProductDataGet, '');
          arrImages.removeWhere((photo) => photo.id == photoId);
          setState(() {});
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {


  return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: ColorRes.white),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: Text(""),
        actions: <Widget>[
          rightSidePopUp(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: InkResponse(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
              firstCarouselView(),
              titleText(StringRes.productName),
              nameTextFiled(),
              titleText(StringRes.descriptionProduct),
              descriptionTextFiled(),
              titleText(StringRes.priceTitle),
              pricePerPis(),
              titleText(StringRes.quantity),
              quantityTextFiled()
            ],
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      bottomNavigationBar: lastDoneButton(),
    );
  }

  Widget firstCarouselView() {
    return Container(
        height: Utils.getDeviceHeight(context) / 3.5,
        child: Stack(
          children: <Widget>[
            arrImages.isNotEmpty
                ? Container(
                    width: Utils.getDeviceWidth(context),
                    color: ColorRes.sliderBg,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return arrImages[index].photo.contains("http")
                            ? CachedNetworkImage(
                                imageUrl: arrImages[index].photo,
                                width: double.infinity,
                                fit: BoxFit.fitHeight,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: ColorRes.validationColorRed,
                                  highlightColor: ColorRes.yellow,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Image.file(File(arrImages[index].photo),
                                fit: BoxFit.fitHeight);
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
                    ),
                  )
                : Container(
                    width: Utils.getDeviceWidth(context),
                    height: Utils.getDeviceHeight(context) / 3.5,
                    child: Image(
                        image: AssetImage(Utils.getAssetsImg("add_product")),
                        fit: BoxFit.fill),
                  ),

            rightSideIcon(2)

//            rightSideIcon(),
          ],
        ));
  }

  titleText(String titleText) {
    return Container(
      margin: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, right: Utils.getDeviceWidth(context)/30, top: Utils.getDeviceWidth(context)/25),
      child: Text(
        titleText,
        textAlign: TextAlign.start,
        style: Theme.of(context)
            .textTheme
            .subtitle
            .copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  nameTextFiled() {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, top: Utils.getDeviceWidth(context)/45, right: Utils.getDeviceWidth(context)/30, bottom:Utils.getDeviceWidth(context)/45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: Container(
              color: ColorRes.white,
              height: 44,
              child: TextFormField(
                maxLines: 1,
                textAlign: TextAlign.left,
                cursorColor: ColorRes.black,
                controller: productName,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isForName = true;
                    });
                  } else {
                    setState(() {
                      isForName = false;
                    });
                  }
                  return null;
                },
              ),
            ),
          ),
          isForName
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

  descriptionTextFiled() {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, top: Utils.getDeviceWidth(context)/45, right: Utils.getDeviceWidth(context)/30, bottom:Utils.getDeviceWidth(context)/45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: Container(
              color: ColorRes.white,
              child: TextFormField(
                maxLines: 5,
                cursorColor: ColorRes.black,
                controller: description,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pricePerPis() {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, top: Utils.getDeviceWidth(context)/45, right: Utils.getDeviceWidth(context)/30, bottom:Utils.getDeviceWidth(context)/45),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            Utils.getAssetsImg("rupee"),
            height: Utils.getDeviceHeight(context)/30,
            width: Utils.getDeviceHeight(context)/30,
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Theme(
                  data: ThemeData(primaryColor: ColorRes.black),
                  child: Container(
                    height: 44,
                    color: ColorRes.white,
                    child: TextFormField(
                      maxLines: 1,
                      cursorColor: ColorRes.black,
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isForPrice = true;
                          });
                        } else {
                          setState(() {
                            isForPrice = false;
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                isForPrice
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
          Expanded(flex: 6, child: Container())
        ],
      ),
    );
  }

  quantityTextFiled() {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getDeviceWidth(context)/30, top: Utils.getDeviceWidth(context)/45, right: Utils.getDeviceWidth(context)/30, bottom:Utils.getDeviceWidth(context)/45),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Theme(
                  data: ThemeData(primaryColor: ColorRes.black),
                  child: Container(
                    height: 44,
                    color: ColorRes.white,
                    child: TextFormField(
                      maxLines: 1,
                      cursorColor: ColorRes.black,
                      controller: quantity,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isForQuantity = true;
                          });
                        } else {
                          setState(() {
                            isForQuantity = false;
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                isForQuantity
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
          Expanded(child: Container())
        ],
      ),
    );
  }

  lastDoneButton() {
    return Container(
      color: ColorRes.black,
      child: MaterialButton(
          color: ColorRes.black,
          height: Utils.getDeviceHeight(context)/13,
          minWidth: Utils.getDeviceWidth(context),
          child: Text(
            widget.productId != null ? StringRes.update : StringRes.done,
            style: TextStyle(color: ColorRes.white, fontSize: 20),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              if (!isForName && !isForPrice && !isForQuantity) {
                if (arrImages.isNotEmpty && arrImages.length > 0) {
                  widget.productId != null
                      ? updateProductApi()
                      : productInsertApi();
                } else {
                  print("---->" + arrImages.length.toString());
                  Utils.showToast("Please add at least one image");
                }
              }
            }
          }),
    );
  }

  rightSidePopUp() {
    return widget.productId != null
        ? PopupMenuButton<String>(
            onSelected: choiceAction,
            offset: Offset(0, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            itemBuilder: (BuildContext con) {
              return ProductRefConstants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  height: Utils.getDeviceHeight(context) / 17,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(choice),
                  ),
                );
              }).toList();
            })
        : Container();
  }

  void choiceAction(String choice) {
    if (choice == ProductRefConstants.SecondItem) {
      print('I Second Item');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return customDialog(StringRes.deleteProductMsg, 2);
          });
    }
  }

  customDialog(String categoryName, int i) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: i == 2 ? 130 : 145,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                child: Text(
                  categoryName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                height: 60,
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: i == 2
                          ? EdgeInsets.only(top: 0)
                          : EdgeInsets.only(top: 0),
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
                      padding: i == 2
                          ? EdgeInsets.only(top: 0)
                          : EdgeInsets.only(top: 0),
                      child: MaterialButton(
                        color: ColorRes.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          i == 2 ? StringRes.delete : StringRes.done,
                          style: TextStyle(color: ColorRes.white),
                        ),
                        onPressed: () {
                          if (i == 1) {
                          } else if (i == 2) {
                            deleteProductApi();
                          } else if (i == 3) {}
//                          addCategory.text = "";
                          Navigator.pop(context);
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

  rightSideIcon(int delete) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.library_add, color: ColorRes.white),
            onPressed: showImageDialog),
        arrImages.isNotEmpty && arrImages.length > 0
            ? IconButton(
                icon: Icon(Icons.clear, color: ColorRes.white),
                onPressed: () {
                  if (arrImages[selectImageIndex].id != null) {
                    deleteImage(arrImages[selectImageIndex].id);
                  } else {
                    arrImages.removeAt(selectImageIndex);
                    setState(() {});
                  }
                })
            : Container()
      ],
    );
  }

  showImageDialog() {

    FocusScope.of(context).requestFocus(FocusNode());

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

                  Utils.getImage(Const.typeGallery).then((file) {
                    if (file != null) {
                      ProductPhoto photos = ProductPhoto();
                      photos.photo = file.path;
                      if (product.photos == null) product.photos = List();
                      arrImages.add(photos);

                      setState(() {});
                    }
                  });
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
                  Utils.getImage(Const.typeCamera).then((file) {
                    if (file != null) {
                      ProductPhoto photos = ProductPhoto();
                      photos.photo = file.path;
                      if (product.photos == null) product.photos = List();
                      arrImages.add(photos);
                      setState(() {});
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //API Product calling.

  Future<void> productInsertApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      AddProductRequest rq = AddProductRequest();
      rq.category = widget.categoryId;
      rq.productName = productName.text;
      rq.description = description.text;
      rq.price = price.text;
      rq.perQuantity = quantity.text;

      List<File> arrFile = List();

      for (int i = 0; i < arrImages.length; i++) {
        if (!arrImages[i].photo.contains("http")) {
          File file = File(arrImages[i].photo);
          arrFile.add(file);
        }
      }

      CommonView.progressDialog(true, context);

      WebApi()
          .uploadImageProduct(WebApi.rqProduct, rq, arrFile)
          .then((baseResponse) async {
        CommonView.progressDialog(false, context);

        if (baseResponse != null) {
          if (baseResponse.success) {

            Utils.showToast(StringRes.productInsertMsg);
            productName.text = "";
            description.text = "";
            price.text = "";
            quantity.text = "";
            Navigator.pop(context, true);
          } else {
            Utils.showToast(baseResponse.message);
          }
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  Future<void> updateProductApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      CommonView.progressDialog(true, context);

      AddProductRequest rq = AddProductRequest();
      rq.productId = widget.productId;
      rq.category = widget.categoryId;
      rq.productName = productName.text;
      rq.description = description.text;
      rq.price = price.text;
      rq.perQuantity = quantity.text;

      List<File> arrFile = List();

      for (int i = 0; i < arrImages.length; i++) {
        if (!arrImages[i].photo.contains("http")) {
          File file = File(arrImages[i].photo);
          arrFile.add(file);
        }
      }
      setState(() {
        isLoading = true;
      });
      WebApi()
          .uploadImageProduct(WebApi.rqProductUpdate, rq, arrFile)
          .then((baseResponse) async {
        if (baseResponse != null) {
          setState(() {
            isLoading = false;
          });

          if (baseResponse.success) {
            CommonView.progressDialog(false, context);
            Utils.showToast(StringRes.updateProductSuccess);
            productName.text = "";
            description.text = "";
            price.text = "";
            quantity.text = "";
            Navigator.pop(context, true);
          } else {
            CommonView.progressDialog(false, context);
            Utils.showToast(baseResponse.message);
          }
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
        setState(() {
          isLoading = false;
        });
        Utils.showToast(StringRes.pleaseTryAgain);
      });
    }
  }

  getProductList() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.get, WebApi.rqProduct, null, Injector.accessToken)
          .then((baseResponse) async {
        setState(() {
          isLoading = false;
        });

        if (baseResponse.success) {
          getCategoryAndProduct = new List<GetCategoryAndProduct>();
          baseResponse.data.forEach((v) {
            getCategoryAndProduct.add(GetCategoryAndProduct.fromJson(v));
          });
          print("getCategoryAndProduct ${getCategoryAndProduct.length}");

          for (int i = 0; i < getCategoryAndProduct.length; i++) {
            if (getCategoryAndProduct[i].id == widget.categoryId) {
              for (int j = 0;
                  j < getCategoryAndProduct[i].products.length;
                  j++) {
                if (getCategoryAndProduct[i].products[j].id ==
                    widget.productId) {
                  Product products = getCategoryAndProduct[i].products[j];
                  productName.text = products.productName;
                  description.text = products.description;
                  price.text = products.price.toString();
                  quantity.text = products.perQuantity.toString();
                  if (products.photos != null && products.photos.length > 0) {
                    arrImages = products.photos;
                  }
                }
              }
            }
          }

          setState(() {});
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  getProductById(int productId) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.get, WebApi.rqProduct + "/$productId", null,
              Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          setState(() {
            product = Product.fromJson(baseResponse.data);
            productName.text = product.productName;
            description.text = product.description;
            price.text = product.price?.toString();
            quantity.text = product.perQuantity?.toString();
            arrImages = product.photos ?? List();
          });
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  deleteProductApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      WebApi()
          .callAPI(Const.delete, "${WebApi.rqProduct}/${widget.productId}",
              null, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse != null && baseResponse.success) {
          Utils.showToast(StringRes.deleteProductSuccess);
          Navigator.pop(context, true);

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

class ProductRefConstants {
  static const String SecondItem = 'Delete Product';

  static const List<String> choices = <String>[SecondItem];
}
