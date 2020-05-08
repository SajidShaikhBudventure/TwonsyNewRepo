class RefreshToken {
  String refreshToken;

  RefreshToken({this.refreshToken});

  RefreshToken.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}
