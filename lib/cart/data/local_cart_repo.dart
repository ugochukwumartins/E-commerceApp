import 'package:ecommerce_app/src/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Stream<Cart> watchCart();

  Future<void> setCart(Cart cart);
}

final localCartRepoProvider = Provider<LocalCartRepository>((ref) {
  throw UnimplementedError();
});

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}
final remoteCartRepoProvider = Provider<RemoteCartRepository>((ref) {
  throw UnimplementedError();
});
