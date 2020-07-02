import 'package:marketplace/model/register.dart';

class SignInRequest {
  String email;
  String password;

  SignInRequest({this.email, this.password});

  SignInRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class BaseResponse<T> {
  bool success;
  String message;
  T data;
  Meta meta;

  BaseResponse({this.success, this.message, this.data, this.meta});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
    print(json);

    if (json.containsKey("meta") && json["meta"] != null) {
      meta = new Meta.fromJson(json['meta']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class Meta {
  int currentPage;
  int count;
  String prevPageUrl;
  String nextPageUrl;
  bool hasMorePages;

  Meta(
      {this.currentPage,
      this.count,
      this.prevPageUrl,
      this.nextPageUrl,
      this.hasMorePages});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    count = json['count'];
    prevPageUrl = json['prev_page_url'];
    nextPageUrl = json['next_page_url'];
    hasMorePages = json['has_more_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['count'] = this.count;
    data['prev_page_url'] = this.prevPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['has_more_pages'] = this.hasMorePages;
    return data;
  }
}
