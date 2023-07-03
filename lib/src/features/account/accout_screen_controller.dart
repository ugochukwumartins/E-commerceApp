import 'package:ecommerce_app/src/auth/data/fake_auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));

  final FakeAuthRepository authRepository;

  Future<bool> singOut() async {
    try {
      state = const AsyncValue.loading();
      await authRepository.SignOut();
      state = AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final acountScreenConttrolProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
        (ref) {
  final authrepo = ref.watch(authRepositoryProvider);
  return AccountScreenController(
    authRepository: authrepo,
  );
});
