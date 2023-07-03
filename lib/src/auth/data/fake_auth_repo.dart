import 'package:ecommerce_app/src/models/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  final _authState = InMemoryStotr<AppUser?>(null);
  Stream<AppUser?> authSateChanges() => _authState.stream;
  AppUser? get currenntUser => _authState.value;
  Future<void> SignInWithEmailAndPassword(String email, String password) async {
    _createNewUser(email);
  }

  Future<void> CreateUserWithEmailAndPassword(
      String email, String password) async {
    _createNewUser(email);
  }

  Future<void> SignOut() async {
    _authState.value = null;
  }

  void _createNewUser(String email) {
    if (currenntUser == null) {
      _authState.value =
          AppUser(uid: email.split('').reversed.join(), email: email);
    }
  }
}

final authRepositoryProvider = Provider.autoDispose<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth._authState.close());
  return auth;
});
final authStateChangesRepositoryProvider =
    StreamProvider.autoDispose<AppUser?>((ref) {
  final authrepo = ref.watch(authRepositoryProvider).authSateChanges();
  return authrepo;
});
