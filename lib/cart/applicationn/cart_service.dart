import 'dart:math';

import 'package:ecommerce_app/cart/data/local_cart_repo.dart';
import 'package:ecommerce_app/cart/mutable_cart.dart';
import 'package:ecommerce_app/src/auth/data/fake_auth_repo.dart';
import 'package:ecommerce_app/src/features/data_layer/product_repository.dart';
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
      ref.read(localCartRepoProvider).setCart(cart);
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
final cartItemCount = Provider<int>((ref) {
  return ref
      .watch(cartProvider)
      .maybeMap(data: (cart) => cart.value.items.length, orElse: () => 0);
  // return cartValue.maybeWhen(
  //     data: (cart) => cart.items.length, orElse: () => 0);
});
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider).value ?? const Cart();
  final productsList =
      ref.watch(productsRepositortProvider).getProductList() ?? [];

  if (cart.items.isNotEmpty && productsList.isNotEmpty) {
    var total = 0.0;
    for (final item in cart.items.entries) {
      final product =
          productsList.firstWhere((product) => product.id == item.key);
      total += product.price * item.value;
    }
    return total;
  } else {
    return 0.0;
  }
  //     data: (cart) => cart.items.length, orElse: () => 0);
});
final itemAvailableQuantityProvider =
    Provider.autoDispose.family<int, Product>((ref, product) {
  final cart = ref.watch(cartProvider).value;

  if (cart != null) {
    int quantity = cart.items[product.id] ?? 0;
    return max(0, product.availableQuantity - quantity);
  } else {
    return product.availableQuantity;
  }
});
