import 'dart:io';

class PhotoUploadRequest {
  Photos photos;

  PhotoUploadRequest({this.photos});

  PhotoUploadRequest.fromJson(Map<String, dynamic> json) {
    photos = json['photos[]'] != null ? new Photos.fromJson(json['photos[]']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.photos != null) {
      data['photos[]'] = this.photos.toJson();
    }
    return data;
  }
}

class Photos {

  File img;

  Photos({this.img});

Photos.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}



class PhotoUploadResponse {
  int id;
  String photo;

  PhotoUploadResponse({this.id, this.photo});

  PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
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
