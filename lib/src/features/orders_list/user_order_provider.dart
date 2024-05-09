import 'package:ecommerce_app/src/auth/data/fake_auth_repo.dart';
import 'package:ecommerce_app/src/features/orders_list/fake_order_repositorty.dart';
import 'package:ecommerce_app/src/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesRepositoryProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  } else {
    // If the user is null, just return an empty screen.
    return const Stream.empty();
  }
});
