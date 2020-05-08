class SocialLoginRequest {
  String firstname;
  String lastname;
  String email;
  String socialId;
  String socialProvider;

  SocialLoginRequest(
      {this.firstname,
        this.lastname,
        this.email,
        this.socialId,
        this.socialProvider});

  SocialLoginRequest.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    socialId = json['social_id'];
    socialProvider = json['social_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['social_id'] = this.socialId;
    data['social_provider'] = this.socialProvider;
    return data;
  }
}
