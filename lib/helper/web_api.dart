import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/addproduct.dart';
import 'package:marketplace/model/refresh_token.dart';
import 'package:marketplace/model/register.dart';
import 'package:marketplace/model/signin.dart';

import 'constant.dart';

class WebApi {
//  static const baseUrl = "http://13.127.186.25/townsy-marketplace/api/v1"; // prod url
//  static const baseUrl = "http://13.233.208.36/townsy-marketplace/api/v1";
  static const baseUrl = "https://www.townsy.in/api/v1/";

  static String rqLogin = "/login";
  static String rqRegister = "/register";
  static String rqSocial = "/social";
  static String rqLogout = "/logout";
  static String rqForgot = "/forgot/password";
  static String rqBusinessPhoto = "/business/photo";
  static String rqBusiness = "/business";
  static String rqBusinessMe = "/business/me";
  static String rqProduct = "/product";
  static String rqProducts = "/product?page=";
  static String rqProductsList = "/product_list";
  static String rqCategory = "/category";
  static String rqDeleteImage = "/product/photo/";
  static String rqProductUpdate = "/product/update";
  static String terms = "/terms";
  static String privacy = "/privacy/policy";
  static String rating = "/business/ratings";
  static String reviews = "/business/reviews?page=";
  static String reviewReplay = "/business/reply/";
  static String guidelines = "/guidelines";
  static String sendOtp = "/send/otp";
  static String verifyOtp = "/verify/otp";
  static String analytics = "​/analytics";
  static String userProfile = "/user/profile";
  static String refreshTK = "/refresh/token";
  static String session = "/business/session";
  static String visit = "/business/visit";
  static String update = "/check/update";

  static getRequest(String req, String data) {
    return {'apiRequest': req, 'data': data};
  }

  Dio dio = Dio();

  initDio(String apiReq, int type, String token) {
    var headers;
    String acceptHeader;
    String contentTypeHeader;
    String authorizationHeader;

    if (type == 1) {
      print("GET or POST method type 1 api call");
      acceptHeader = 'application/json';
      authorizationHeader = 'Bearer ' + token;
    } else if (type == 2) {
      print("DELETE method type 2 api call");
      acceptHeader = 'application/json';
      authorizationHeader = 'Bearer ' + token;
    } else if (type == 3) {
      print("PUT method type 3 api call");
      acceptHeader = 'application/json';
      authorizationHeader = 'Bearer ' + token;
      contentTypeHeader = 'application/json';
    } else if (type == 4) {
      print("post with access token method type 4 api call");
      acceptHeader = 'application/json';
      authorizationHeader = 'Bearer ' + token;
      contentTypeHeader = 'multipart/form-data';
    } else if (type == 5) {
      print("GET method type 5 api call");
      acceptHeader = 'application/json';
    } else if (type == 0 || type == 6) {
      print("POST method type 0 api call");
      acceptHeader = 'application/json';
      contentTypeHeader = 'multipart/form-data';
      authorizationHeader = "";
    }

    headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
      HttpHeaders.authorizationHeader: authorizationHeader,
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
  "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
    };
    
//  print("{"+HttpHeaders.acceptHeader+" : "+acceptHeader+","+ HttpHeaders.contentTypeHeader+" : "+contentTypeHeader+","+HttpHeaders.authorizationHeader+" : "+authorizationHeader+"}");
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + apiReq,
        connectTimeout: 20000,
        receiveTimeout: 3000,
         contentType : "application/json",
        headers: headers);

    dio.options = options;
    print('Base URL :'+baseUrl + apiReq);

    return dio;
  }

  Future<BaseResponse> callAPI(int num, String apiReq,
      Map<String, dynamic> jsonMap, String token) async {
    initDio(apiReq, num, token);
    print("request_" + apiReq);
    print("request_map_  " + jsonMap.toString());
    try {
      BaseResponse baseResponse;


      if (num == Const.get || num == Const.getReqNotToken) {
        await dio.get("").then((response) {
          baseResponse = BaseResponse.fromJson(response.data);
        }).catchError((e) {
          handleException(e, num, apiReq, jsonMap);
        });
      } else if (num == Const.delete) {
        await dio.delete("").then((response) {
          baseResponse = BaseResponse.fromJson(response.data);
        }).catchError((e) {
          handleException(e, num, apiReq, jsonMap);
        });
      } else if (num == Const.put) {
        await dio.put("", data: jsonMap).then((response) {
          baseResponse = BaseResponse.fromJson(response.data);
        }).catchError((e) async {
          handleException(e, num, apiReq, jsonMap);
        });
      } else {
        await dio.post("", data: json.encode(jsonMap)).then((response) {
          baseResponse = BaseResponse.fromJson(response.data);
        }).catchError((e) {
          handleException(e, num, apiReq, jsonMap);
        });
      }

      print(apiReq + "_" + baseResponse.toJson().toString());

      return baseResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<BaseResponse> refreshToken(int num, String apiReq,
      Map<String, dynamic> jsonMap, String token) async {
    initDio(apiReq, num, token);
    try {
      BaseResponse baseResponse;

      await dio.post("", data: json.encode(jsonMap)).then((response) async {
        baseResponse = BaseResponse.fromJson(response.data);

        if (baseResponse.success) {
          Auth auth = Auth.fromJson(baseResponse.data);
          await Injector.updateAuthData(auth);
        }
      }).catchError((e) {
        baseResponse = BaseResponse.fromJson(e.response.data);
      });

      print(apiReq + "_" + baseResponse.toJson().toString());

      return baseResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  initDioImg(String apiReq, String token) {
    String acceptHeader = 'application/json';
    String authorizationHeader = 'Bearer ' + token;
    String contentTypeHeader = 'multipart/form-data';
    print("contentTypeHeader " + acceptHeader);
    print("accessToken " + authorizationHeader);
    print("accessToken " + authorizationHeader);
    var headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.authorizationHeader: authorizationHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
      
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
  "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
    };
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + apiReq,
        connectTimeout: 20000,
        receiveTimeout: 3000,
         contentType : "application/json",
        headers: headers);
    dio.options = options;
    return dio;
  }

  Future<FormData> uploadImage(List<File> file) async {
    FormData formData = new FormData();

    for (int i = 0; i < file.length; i++) {
      String fileName = file[i].path.split('/').last;
      formData = FormData.fromMap({
        "photos[]":
            await MultipartFile.fromFile(file[i].path, filename: fileName
            
            ),
      });
    }
    return formData;
  }

  Future<dynamic> uploadImageProduct(
      String apiReq, AddProductRequest rq, List<File> files) async {
    initDio(apiReq, Const.postWithAccess, Injector.accessToken);

    FormData formData;

    formData = FormData.fromMap({
      "product_id": rq.productId,
      "category": rq.category,
      "product_name": rq.productName,
      "description": rq.description,
      "price": rq.price,
      "per_quantity": rq.perQuantity
    });

    for (int i = 0; i < files.length; i++) {
      String fileName = files[i].path.split('/').last;

      formData.files.add(MapEntry("photos[]",
          await MultipartFile.fromFile(files[i].path, filename: fileName
         
          )));
    }

    BaseResponse _response;
    await dio.post("", data: formData).then((response) {
      _response = BaseResponse.fromJson(response.data);
    }).catchError((e) {
      _response = BaseResponse.fromJson(e.response.data);
      Utils.showToast(_response.message);
    });
    print(_response);

    return _response;
  }

  Future<BaseResponse> editProfile(String apiReq, File files) async {
    initDio(apiReq, Const.postWithAccess, Injector.accessToken);

    FormData formData;
    String fileName = files.path.split('/').last;

    formData = FormData.fromMap({"firstname": "", "lastname": ""});

    formData.files.add(MapEntry("profile",
        await MultipartFile.fromFile(files.path, filename: fileName
       )));

    BaseResponse _response;
    await dio.post("", data: formData).then((response) {
      _response = BaseResponse.fromJson(response.data);
    }).catchError((e) {
      _response = BaseResponse.fromJson(e.response.data);
      Utils.showToast(_response.message);
    });
    print(_response);

    return _response;
  }

  Future<BaseResponse> uploadImgApi(
      String apiReq, String token, List<File> images) async {
    initDioImg(apiReq, token);
    try {
      var response;

      await uploadImage(images).then((formData) async {
        response = await dio.post("", data: formData).catchError((e) {
          Utils.showToast(apiReq + "_" + e.toString());
          return null;
        });
      });

      print(apiReq + "_" + response?.data.toString());
      if (response.statusCode == 200) {
        BaseResponse _response = BaseResponse.fromJson(response.data);

        if (_response != null) {
          if (_response.success) {
            return _response;
          } else {
            Utils.showToast(_response.message ?? "Please try again later.");
            return null;
          }
        } else {
          Utils.showToast("Please try again later");
          return null;
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  getFiles(List<File> files) async {
    return files.forEach((file) async {
      String fileName = file.path.split('/').last;
      await MultipartFile.fromFile(file.path, filename: fileName);
    });
  }

  Future<BaseResponse> handleException(
      e, int num, String apiReq, Map<String, dynamic> jsonMap) async {
    BaseResponse baseResponse = BaseResponse.fromJson(e.response.data);
    if (e.response.statusCode == 401) {
      RefreshToken rq = RefreshToken();
      rq.refreshToken = Injector.auth.refreshToken;
      BaseResponse baseResponse = await refreshToken(Const.postRefreshToken,
          refreshTK, rq.toJson(), Injector.auth.refreshToken);
      if (baseResponse.success) {
        initDio(apiReq, num, Injector.auth.accessToken);
        callAPI(num, apiReq, jsonMap, Injector.auth.accessToken);
      } else {
        Utils.showToast(baseResponse.message);
      }
    } else {
      Utils.showToast(baseResponse.message);
    }
    return baseResponse;
  }
  

/* Future<BaseResponse> handleException(
      e, int num, String apiReq, Map<String, dynamic> jsonMap) async {
    BaseResponse baseResponse = BaseResponse.fromJson(e.response.data);

    if (e.response.statusCode == 401) {
      RefreshToken rq = RefreshToken();
      rq.refreshToken = Injector.auth.refreshToken;
      await refreshToken(Const.postRefreshToken, refreshTK, rq.toJson(),
          Injector.auth.refreshToken);
      initDio(apiReq, num, Injector.auth.accessToken);
      callAPI(num, apiReq, jsonMap, Injector.auth.accessToken);
    } else {
      Utils.showToast(baseResponse.message);
    }

    return baseResponse;
  }*/

  
}
class Header{
  String accept;
  String authorization;
  bool contenttype;

  Map<String, dynamic> toJson() =>
  {
    'accept': accept,
    'content-type': contenttype,
    authorization : authorization,
  }; 
}