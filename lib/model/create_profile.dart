import 'dart:convert';

class BusinessCreateRequest {
//  int id;
  String business_name;
  String telephone;
  String phone;
  String address;
  String categories;
  String profile;
  var business_type;
  String other_info;
  String latitude;
  String longitude;
  List<Time> time;

  BusinessCreateRequest(
      {this.business_name,
      this.telephone,
      this.phone,
      this.address,
      this.categories,
      this.profile,
      this.business_type,
      this.other_info,
      this.latitude,
      this.longitude,
      this.time
      });

  BusinessCreateRequest.fromJson(Map<String, dynamic> json) {
    business_name = json['business_name'];
    telephone = json['telephone'];
      phone = json['phone'];
    address = json['address'];
    categories = json['categories'];
    profile = json['profile'];
    other_info = json['other_info'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    business_type = json['business_type'].cast<int>();
    if (json['time'] != null) {
      time = new List<Time>();
      json['time'].forEach((v) {
        time.add(new Time.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.business_name;
    data['telephone'] = this.telephone;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['categories'] = this.categories;
//    data['profile'] = this.profile;
    data['other_info'] = this.other_info;
    data['business_type'] = this.business_type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.time != null) {
      data['time'] = jsonEncode(this.time.map((v) => v.toJson()).toList());
    }

    return data;
  }
}

class BusinessType {
  int businessTypeId;

  BusinessType({
    this.businessTypeId,
  });

  BusinessType.fromJson(Map<String, dynamic> json) {
    businessTypeId = json['businessTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessTypeId'] = this.businessTypeId;
    return data;
  }
}

class Time {
  String day;
  String startTime;
  String endTime;
  bool isCheck;

  Time({this.day, this.startTime, this.endTime,this.isCheck});

  Time.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
