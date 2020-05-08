import 'dart:convert';

import 'package:marketplace/model/register.dart';

import 'create_profile.dart';

class UserData {
  int id;
  Auth auth;
  String firstname;
  String lastname;
  String email;
  String businessName;
  String profile;
  String phone;
  String telephone;
  String socialId;
  int socialProvider;
  String address;
  String categories;
  String otherInfo;
  String latitude;
  String longitude;
  int isPrivate;
  int profileStatus;
  List<PhotosBusiness> photos;

  UserData({
    this.id,
    this.auth,
    this.firstname,
    this.lastname,
    this.email,
    this.businessName,
    this.profile,
    this.phone,
    this.telephone,
    this.socialId,
    this.socialProvider,
    this.address,
    this.categories,
    this.otherInfo,
    this.latitude,
    this.longitude,
    this.isPrivate,
    this.profileStatus,
    this.photos,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    businessName = json['business_name'];
    profile = json['profile'];
    phone = json['phone'];
    telephone = json['telephone'];
    socialId = json['social_id'];
    socialProvider = json['social_provider'];
    address = json['address'];
    categories = json['categories'];
    otherInfo = json['other_info'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isPrivate = json['is_private'];
    profileStatus = json['profile_status'];

    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
    if (json['photos'] != null) {
      photos = new List<PhotosBusiness>();
      json['photos'].forEach((v) {
        photos.add(new PhotosBusiness.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['business_name'] = this.businessName;
    data['profile'] = this.profile;
    data['phone'] = this.phone;
    data['telephone'] = this.telephone;
    data['social_id'] = this.socialId;
    data['social_provider'] = this.socialProvider;
    data['address'] = this.address;
    data['categories'] = this.categories;
    data['other_info'] = this.otherInfo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_private'] = this.isPrivate;
    data['profile_status'] = this.profileStatus;

    if (this.auth != null) {
      data['auth'] = this.auth.toJson();
    }

    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class UserBusinessData {
  int id;
  Auth auth;
  String firstname;
  String lastname;
  String email;
  String businessName;
  String profile;
  String phone;
  String telephone;
  String socialId;
  int socialProvider;
  String address;
  List<int> businessType;
  String categories;
  String otherInfo;
  String webProfile;
  String latitude;
  String longitude;
  int isPrivate;
  int profileStatus;
  List<PhotosBusiness> photos;
  List<Time> time;

  UserBusinessData(
      {this.id,
      this.auth,
      this.firstname,
      this.lastname,
      this.email,
      this.businessName,
      this.profile,
      this.phone,
      this.telephone,
      this.socialId,
      this.socialProvider,
      this.address,
      this.businessType,
      this.categories,
      this.otherInfo,
      this.webProfile,
      this.latitude,
      this.longitude,
      this.isPrivate,
      this.profileStatus,
      this.photos,
      this.time});

  UserBusinessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    businessName = json['business_name'];
    profile = json['profile'];
    phone = json['phone'];
    telephone = json['telephone'];
    socialId = json['social_id'];
    socialProvider = json['social_provider'];
    address = json['address'];
    businessType = json['business_type'].cast<int>();
    categories = json['categories'];
    otherInfo = json['other_info'];
    webProfile = json['web_profile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isPrivate = json['is_private'];
    profileStatus = json['profile_status'];
    if (json['photos'] != null) {
      photos = new List<PhotosBusiness>();
      json['photos'].forEach((v) {
        photos.add(new PhotosBusiness.fromJson(v));
      });
    }
    try {
      if ((json['time']) != null) {
        time = new List<Time>();
        (json['time']).forEach((v) {
          time.add(new Time.fromJson(v));
        });
      }
    } catch (e) {
      print(e);
    }
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['business_name'] = this.businessName;
    data['profile'] = this.profile;
    data['phone'] = this.phone;
    data['telephone'] = this.telephone;
    data['social_id'] = this.socialId;
    data['social_provider'] = this.socialProvider;
    data['address'] = this.address;
    data['business_type'] = this.businessType;
    data['categories'] = this.categories;
    data['other_info'] = this.otherInfo;
    data['web_profile'] = this.webProfile;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_private'] = this.isPrivate;
    data['profile_status'] = this.profileStatus;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    if (this.time != null) {
      data['time'] = jsonEncode(this.time.map((v) => v.toJson()).toList());
    }

    if (this.auth != null) {
      data['auth'] = this.auth.toJson();
    }

    return data;
  }
}

class PhotosBusiness {
  int id;
  String photo;

  PhotosBusiness({this.id, this.photo});

  PhotosBusiness.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    return data;
  }
}
