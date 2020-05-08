import 'dart:io';
import 'package:dio/dio.dart';

class AddProductRequest {
  int category;
  int productId;
  String productName;
  String description;
  String price;
  String perQuantity;

  AddProductRequest(
      {this.category,
      this.productName,
      this.description,
      this.price,
      this.perQuantity});

  AddProductRequest.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("product_id") && json['product_id'] != null) {
      productId = json['product_id'];
    }
    category = json['category'];
    productName = json['product_name'];
    description = json['description'];
    price = json['price'];
    perQuantity = json['per_quantity'];
  }

  getFiles(List<File> files) {
    return files.forEach((file) async {
      String fileName = file.path.split('/').last;
      MultipartFile.fromFile(file.path, filename: fileName);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['category'] = this.category;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['price'] = this.price;
    data['per_quantity'] = this.perQuantity;
     return data;
  }
}

class ProductPhoto {
  int id;
  String photo;

  ProductPhoto({this.id, this.photo});

  ProductPhoto.fromJson(Map<String, dynamic> json) {
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
