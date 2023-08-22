import 'package:ecommerce_app/cart/data/local_cart_repo.dart';
import 'package:ecommerce_app/src/models/cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastCartRepo implements LocalCartRepository {
  SembastCartRepo(this.db);
  final Database db;
  final store = StoreRef.main();
  static Future<Database> createDataBase(String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();

    return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
  }

  static Future<SembastCartRepo> makeDefault() async {
    return SembastCartRepo(
      await createDataBase('deafault.db'),
    );
  }

  static const cartitemKey = 'cartItems';

  @override
  Future<Cart> fetchCart() async {
    final cartJson = await store.record(cartitemKey).get(db) as String?;

    if (cartJson != null) {
      return Cart.fromJson(cartJson);
    } else {
      return const Cart();
    }
  }

  @override
  Future<void> setCart(Cart cart) {
    return store.record(cartitemKey).put(db, cart.toJson());
  }

  @override
  Stream<Cart> watchCart() {
    final record = store.record(cartitemKey);
    return record.onSnapshot(db).map(
      (snapshort) {
        if (snapshort != null) {
          return Cart.fromJson(snapshort.value as String);
        } else {
          return const Cart();
        }
      },
    );
  }
}
