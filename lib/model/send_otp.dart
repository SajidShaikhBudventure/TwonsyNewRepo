class SendOtpRequest {
  String phone;
  String countryCode;

  SendOtpRequest({this.phone, this.countryCode});

  SendOtpRequest.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    return data;
  }
}


class VerifyRequest {
  String otp;
  VerifyRequest({this.otp});

  VerifyRequest.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    return data;
  }
}
