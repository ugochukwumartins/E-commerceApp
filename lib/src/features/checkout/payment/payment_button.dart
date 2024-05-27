import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/features/checkout/payment/payment_button_controller.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends ConsumerWidget {
  const PaymentButton({super.key});


  @override
  Widget build(BuildContext context, ref) {
    ref.listen(
      paymentButtonController,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(paymentButtonController);
    return PrimaryButton(
      text: 'Pay'.hardcoded,
      isLoading: state.isLoading,
      onPressed: () => state.isLoading
          ? null
          : ref.read(paymentButtonController.notifier).pay(),
    );
  }
}
