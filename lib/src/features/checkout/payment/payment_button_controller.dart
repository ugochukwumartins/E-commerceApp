import 'package:ecommerce_app/src/features/checkout/fake_checkout_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentButtonController extends StateNotifier<AsyncValue<void>> {
  final FakeCheckoutService checkoutService;

  PaymentButtonController({required this.checkoutService})
      : super(const AsyncData(null));
  Future<void> pay() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => checkoutService.placeOrder());
  }
}

final paymentButtonController = StateNotifierProvider.autoDispose<
    PaymentButtonController, AsyncValue<void>>((ref) {
  final checkoutService = ref.watch(checkoutServiceProvider);
  return PaymentButtonController(checkoutService: checkoutService);
});
