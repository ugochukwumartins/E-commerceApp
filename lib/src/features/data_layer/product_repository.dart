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
  Product? getProduct(String id) {
    return _getProduct(_product, id);
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
  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

//

final productsRepositortProvider = Provider<ProductRepo>((ref) {
  return ProductRepo();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositortProvider);
  return productsRepository.watchProductList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositortProvider);
  return productsRepository.fetchProductList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productsRepository = ref.watch(productsRepositortProvider);
  return productsRepository.watcProduct(id);
});
//


