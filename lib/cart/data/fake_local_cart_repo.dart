import 'package:ecommerce_app/cart/data/local_cart_repo.dart';
import 'package:ecommerce_app/src/models/cart.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  FakeLocalCartRepository({this.addDelay = true});

  final bool addDelay;

  final _cart = InMemoryStotr<Cart>(const Cart());

  @override
  Future<Cart> fetchCart() => Future.value(_cart.value);

  @override
  Stream<Cart> watchCart() => _cart.stream;

  @override
  Future<void> setCart(Cart cart) async {
    await delay(addDelay);

    _cart.value = cart;
  }
}
