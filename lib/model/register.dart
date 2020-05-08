class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String password;

  RegisterRequest({this.firstName, this.lastName, this.email, this.password});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstname'];
    lastName = json['lastname'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstName;
    data['lastname'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}


class RegisterResponseData {
  int id;
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
  String businessType;
  String otherInfo;
  String latitude;
  String longitude;
  int isPrivate;
  Auth auth;

  RegisterResponseData(
      {this.id,
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
        this.otherInfo,
        this.latitude,
        this.longitude,
        this.isPrivate,
        this.auth});

  RegisterResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    businessName = json['businessName'];
    profile = json['profile'];
    phone = json['phone'];
    telephone = json['telephone'];
    socialId = json['social_id'];
    socialProvider = json['social_provider'];
    address = json['address'];
    businessType = json['business_type'];
    otherInfo = json['other_info'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isPrivate = json['is_private'];
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['businessName'] = this.businessName;
    data['profile'] = this.profile;
    data['phone'] = this.phone;
    data['telephone'] = this.telephone;
    data['social_id'] = this.socialId;
    data['social_provider'] = this.socialProvider;
    data['address'] = this.address;
    data['business_type'] = this.businessType;
    data['other_info'] = this.otherInfo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_private'] = this.isPrivate;
    if (this.auth != null) {
      data['auth'] = this.auth.toJson();
    }
    return data;
  }
}

class Auth {
  String tokenType;
  String accessToken;
  String refreshToken;
  int expiresIn;

  Auth({this.tokenType, this.accessToken, this.refreshToken, this.expiresIn});

  Auth.fromJson(Map<String, dynamic> json) {
    tokenType = json['tokenType'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokenType'] = this.tokenType;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['expiresIn'] = this.expiresIn;
    return data;
  }
}
