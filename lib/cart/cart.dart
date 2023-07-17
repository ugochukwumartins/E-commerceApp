import 'package:ecommerce_app/src/models/item.dart';
import 'package:ecommerce_app/src/models/product.dart';

class Cart {
  const Cart([this.items = const {}]);

  final Map<ProductID, int> items;
}

extension CartItems on Cart {
  List<Item> toItemslist() {
    return items.entries.map((entry) {
      return Item(
        productId: entry.key,
        quantity: entry.value,
      );
    }).toList();
  }
}
