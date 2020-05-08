import 'getProductData.dart';

class GetCategoryResponse {
  List<ProductCategory> data;

  GetCategoryResponse({this.data});

  GetCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductCategory>();
      json['data'].forEach((v) {
        data.add(new ProductCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class ProductCategory {
  int id;
  String category;
  List<Product> products;

  ProductCategory({this.id, this.category, this.products});

  ProductCategory.fromJson(Map<String, dynamic> json) {
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