import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AysncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: error,
      );
    }
  }
}
