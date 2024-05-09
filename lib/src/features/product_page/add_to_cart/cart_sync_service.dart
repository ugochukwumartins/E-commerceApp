import 'dart:math';

import 'package:ecommerce_app/cart/data/local_cart_repo.dart';
import 'package:ecommerce_app/cart/mutable_cart.dart';
import 'package:ecommerce_app/src/auth/data/fake_auth_repo.dart';
import 'package:ecommerce_app/src/features/data_layer/product_repository.dart';
import 'package:ecommerce_app/src/models/app_user.dart';
import 'package:ecommerce_app/src/models/cart.dart';
import 'package:ecommerce_app/src/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }
  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesRepositoryProvider,
        (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      final localCartRepository = ref.read(localCartRepoProvider);
      final localCart = await localCartRepository.fetchCart();
      if (localCart.items.isNotEmpty) {
        final remoteCartRepository = ref.read(remoteCartRepoProvider);
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        final localItemsToAdd = await _getLocalItemToAdd(localCart, remoteCart);

        final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);
        await remoteCartRepository.setCart(uid, updatedRemoteCart);
        await localCartRepository.setCart(const Cart());
      }
    } catch (e) {}
  }

  Future<List<Item>> _getLocalItemToAdd(Cart localCart, Cart remotCart) async {
    final productsRepository = ref.read(productsRepositortProvider);
    final products = await productsRepository.fetchProductList();
    final localItemsToAdd = <Item>[];
    for (final localItem in localCart.items.entries) {
      final productId = localItem.key;
      final int localQuantity = localItem.value;

      final remoteQuantity = remotCart.items[productId] ?? 0;
      final product = products.firstWhere((product) => product.id == productId);
      final cappedLocalQuantity =
          min(localQuantity, product.availableQuantity - remoteQuantity);
      if (cappedLocalQuantity > 0) {
        localItemsToAdd.add(
            Item(productId: productId, quantity: cappedLocalQuantity as int));
      }
    }
    return localItemsToAdd;
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
