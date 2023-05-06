import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepo {
  //making the constructor private
//   ProductRepo._();

// // making the constructor singleton
//   static ProductRepo instance = ProductRepo._();

  final List<Product> _product = kTestProducts;

  List<Product> getProductList() {
    return _product;
  }

  Product? findProduct(String id) {
    return _product.firstWhere((product) => product.id == id);
  }

// asny return type using future
  Future<List<Product>> fetchProductList() {
    return Future.value(_product);
  }

  // asny return type using stream
  Stream<List<Product>> watchProductList() {
    return Stream.value(_product);
  }

  Stream<Product?> watcProduct(String id) {
    return watchProductList().map((products)=> products.firstWhere((product) => product.id == id));
  }
}

final productsRepositortProvider = Provider<ProductRepo>((ref) {
  return ProductRepo();
});
