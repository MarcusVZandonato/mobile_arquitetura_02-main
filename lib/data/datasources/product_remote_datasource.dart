import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }

    final responseBody = utf8.decode(response.bodyBytes);
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    final products = data['products'] as List;
    return products
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('https://dummyjson.com/products/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add product');
    }

    final responseBody = utf8.decode(response.bodyBytes);
    final json = jsonDecode(responseBody);
    return ProductModel.fromJson(json as Map<String, dynamic>);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('https://dummyjson.com/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }

    final responseBody = utf8.decode(response.bodyBytes);
    final json = jsonDecode(responseBody);
    return ProductModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse('https://dummyjson.com/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
