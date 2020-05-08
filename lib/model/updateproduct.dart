import 'dart:io';

class UpdateProductRequest {
  String productId;
  String category;
  String productName;
  String description;
  String price;
  String perQuantity;
  List<File> imageFiles;

  UpdateProductRequest(
      {this.productId,
        this.category,
        this.productName,
        this.description,
        this.price,
        this.perQuantity});

  UpdateProductRequest.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    category = json['category'];
    productName = json['product_name'];
    description = json['description'];
    price = json['price'];
    perQuantity = json['per_quantity'];
    imageFiles = json['photos[]'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['category'] = this.category;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['price'] = this.price;
    data['per_quantity'] = this.perQuantity;
    data['photos[]'] = this.imageFiles;
    return data;
  }
}
