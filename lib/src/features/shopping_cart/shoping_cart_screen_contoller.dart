// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/models/item.dart';
import 'package:ecommerce_app/src/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/cart/applicationn/cart_service.dart';

class ShoppingCartScreenController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartScreenController({
    required this.cartService,
  }) : super(AsyncData(null));

  final CartService cartService;

  Future<void> updateItemQuantity(ProductID productID, int quantity) async {
    state = const AsyncLoading();
    final update = Item(productId: productID, quantity: quantity);
    state = await AsyncValue.guard(() => cartService.setItem(update));
  }

  Future<void> removeItemById(ProductID productID) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => cartService.removeItemByid(productID));
  }
}

final shopingCartScreenController =
    StateNotifierProvider<ShoppingCartScreenController, AsyncValue<void>>(
        (ref) {
  return ShoppingCartScreenController(
      cartService: ref.watch(cartServiceProvider));
});
