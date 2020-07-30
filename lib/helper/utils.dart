import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_html/image_properties.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/helper/imageproperties.dart';
import 'package:marketplace/helper/res.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'constant.dart';

class Utils {

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getAssetsImg(String name) {
    return "assets/images/" + name + ".png";
  }

  static showToast(String message) {

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: ColorRes.black,
        textColor: ColorRes.white
        );
  }

  static Future<bool> isInternetConnectedWithAlert() async {
    bool isConnected = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    } else {
      showToast("Please check your internet connection");
      isConnected = false;
    }
    return isConnected;
  }

  static Future<bool> isInternetConnected() async {
    bool isConnected = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    } else {
      isConnected = false;
    }
    return isConnected;
  }

  static Future<File>  getImage(int type) async {
    
    
     File image= await ImagePicker.pickImage(imageQuality: Const.imgQuality,
      source: type == Const.typeCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null && image.path != null) {

      // Note : iOS not implemented
      image = await FlutterExifRotation.rotateAndSaveImage(path: image.path);
    }
    return image;
  }

static Future<List<String>> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    List<Asset> images = List<Asset>();
  List<String> imagePath = List<String>();
 


    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitleColor:"#000000",
          actionBarTitle: "Townsy App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
     

      for (var r in resultList) {
       var t = await FlutterAbsolutePath.getAbsolutePath(r.identifier);
       print('Width: '+r.originalWidth.toString()+"Height:"+r.originalHeight.toString());
        print('Path:'+t);
        File image;
        if(Platform.isAndroid){
    image = await FlutterExifRotation.rotateImage(path: t);
        }else{
          image = new File(t.toString());
        }
 if(r.originalWidth>4000){
File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 80, 
    targetWidth: 2500, targetHeight: 2000);
    imagePath.add(compressedFile.path);
      
 }else if(r.originalWidth>3000){
File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 80, 
    targetWidth: 2500, targetHeight: 1900);
    imagePath.add(compressedFile.path);
      
 }
 
 else{
  
   
    imagePath.add(image.path);
 }
        
        
      }
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
   return imagePath;

    
  }

}
