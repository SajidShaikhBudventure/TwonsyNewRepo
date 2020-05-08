class EditProfile {

  String profile;

  EditProfile({this.profile});

  EditProfile.fromJson(Map<String, dynamic> json) {
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['profile'] = this.profile;
    return data;
  }
}
