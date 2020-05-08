import 'addproduct.dart';

class GetCategoryAndProduct {
  int id;
  String category;
  List<Product> products;

  GetCategoryAndProduct({this.id, this.category, this.products});

  GetCategoryAndProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int id;
  String productName;
  String description;
  var price;
  String perQuantity;
  String photo;
  int views;
  List<ProductPhoto> photos = List();
//  <l photo;

  Product(
      {this.id,
        this.productName,
        this.description,
        this.price,
        this.perQuantity,
        this.photos,
        this.views,
        this.photo}
      );

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    description = json['description'];
    price = json['price'];
    perQuantity = json['per_quantity'];
    views = json['product_view'];
    photo = json['photo'];
    if (json['photos'] != null) {
      photos = new List<ProductPhoto>();
      json['photos'].forEach((v) {
        photos.add(new ProductPhoto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['price'] = this.price;
    data['per_quantity'] = this.perQuantity;
    data['product_view'] = this.views;
    data['photo'] = this.photo;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class OneProductList {
  int id;
  String photo;

  OneProductList({this.id, this.photo});

  OneProductList.fromJson(Map<String, dynamic> json) {
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

