import 'package:ecommerce_app/src/models/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  Stream<AppUser?> authSateChanges() => Stream.value(null);
  AppUser? get currenntUser => null;
  Future<void> SignInWithEmailAndPassword(
      String email, String password) async {}

  Future<void> CreateUserWithEmailAndPassword(
      String email, String password) async {}
  Future<void> SignOut() async {}
}

final authRepository =
    Provider.autoDispose<FakeAuthRepository>((ref) => FakeAuthRepository());
final authStateChangesRepository = StreamProvider.autoDispose<AppUser?>((ref) {
  final authrepo = ref.watch(authRepository).authSateChanges();
  return authrepo;
});
