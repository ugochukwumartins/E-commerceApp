import 'package:ecommerce_app/cart/applicationn/cart_service.dart';
import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/features/checkout/checkout_screen.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shoping_cart_screen_contoller.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/cart.dart';
import 'package:ecommerce_app/src/models/item.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_items_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shopping cart screen showing the items in the cart (with editable
/// quantities) and a button to checkout.
class ShoppingCartScreen extends ConsumerWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen<AsyncValue<void>>(
      shopingCartScreenController,
      (previous, state) => state.showAlertDialogOnError(context),
    );

final state = ref.watch(shopingCartScreenController);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'.hardcoded),
      ),
      body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final cartvalue = ref.watch(cartProvider);
        return AsyncValueWidget<Cart>(
            value: cartvalue,
            data: (cart) => ShoppingCartItemsBuilder(
                  items: cart.toItemsList(),
                  itemBuilder: (_, item, index) => ShoppingCartItem(
                    item: item,
                    itemIndex: index,
                  ),
                  ctaBuilder: (_) => PrimaryButton(
                      text: 'Checkout'.hardcoded,
                      isLoading: state.isLoading,
                      onPressed: () => context.goNamed(AppRoute.checkout.name)
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     fullscreenDialog: true,
                      //     builder: (_) => const CheckoutScreen(),
                      //   ),
                      // ),
                      ),
                ));
      }
      ),
    );
  }
}
