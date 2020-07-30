import 'package:marketplace/model/getcategory.dart';

class AnalyticsResponse {
  Analytics analytics;
  List<ProductCategory> categories;

  AnalyticsResponse({this.analytics, this.categories});

  AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    analytics = json['analytics'] != null
        ? new Analytics.fromJson(json['analytics'])
        : null;
    if (json['categories'] != null) {
      categories = new List<ProductCategory>();
      json['categories'].forEach((v) {
        categories.add(new ProductCategory.fromJsonAnalytics(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.analytics != null) {
      data['analytics'] = this.analytics.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Analytics {
  int businessView;
  int callCount;
  int directionCount;

  Analytics({this.businessView, this.callCount, this.directionCount});

  Analytics.fromJson(Map<String, dynamic> json) {
    businessView = json['business_view'];
    callCount = json['call_count'];
    directionCount = json['direction_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_view'] = this.businessView;
    data['call_count'] = this.callCount;
    data['direction_count'] = this.directionCount;
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
