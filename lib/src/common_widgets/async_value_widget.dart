import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsysnyValueWidget<T> extends StatelessWidget {
  const AsysnyValueWidget({
    Key? key,
    required this.value,
    required this.data,
  }) : super(key: key);

  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
        data: data,
        error: (e, st) => Center(
              child: ErrorMessageWidget(e.toString()),
            ),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
