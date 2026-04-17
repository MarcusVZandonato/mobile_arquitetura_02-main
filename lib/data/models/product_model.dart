import 'package:mobile_arquitetura_02/domain/entities/product.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final bool isFavorited;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    this.isFavorited = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      image: json["image"],
      description: json["description"] ?? "",
      isFavorited: false,
    );
  }
  factory ProductModel.fromCache(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      image: json["image"],
      description: json["description"] ?? "",
      isFavorited: json["isFavorited"] ?? false,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      description: product.description,
      isFavorited: product.isFavorited,
    );
  }

  Map<String, dynamic> toCache() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "image": image,
      "description": description,
      "isFavorited": isFavorited,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "price": price,
      "description": description,
      "image": image,
      "category": "electronic" 
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    String? description,
    bool? isFavorited,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
