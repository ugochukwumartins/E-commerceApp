import 'package:ecommerce_app/cart/data/local_cart_repo.dart';
import 'package:ecommerce_app/cart/mutable_cart.dart';
import 'package:ecommerce_app/src/auth/data/fake_auth_repo.dart';
import 'package:ecommerce_app/src/models/cart.dart';
import 'package:ecommerce_app/src/models/item.dart';
import 'package:ecommerce_app/src/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currenntUser;

    if (user != null) {
      return ref.read(remoteCartRepoProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepoProvider).fetchCart();
    }
  }

  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currenntUser;

    if (user != null) {
      ref.read(remoteCartRepoProvider).setCart(user.uid, cart);
    } else {
      ref.read(localCartRepoProvider)..setCart(cart);
    }
  }

  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  Future<void> removeItemByid(ProductID productID) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productID);
    await _setCart(updated);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});

final cartProvider = StreamProvider<Cart>((ref) {
  final user = ref.watch(authStateChangesRepositoryProvider).value;

  if (user != null) {
    return ref.watch(remoteCartRepoProvider).watchCart(user.uid);
  } else {
    return ref.watch(localCartRepoProvider).watchCart();
  }
});
