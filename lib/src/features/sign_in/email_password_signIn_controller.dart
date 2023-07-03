import 'package:ecommerce_app/src/auth/data/fake_auth_repo.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController(
      {required EmailPasswordSignInFormType formType,
      required this.authRepository})
      : super(EmailPasswordSignInState(formType: formType));

  final FakeAuthRepository authRepository;

  Future<bool> submit(String email, String password) async {
    state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _auth(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _auth(String email, String password) async {
    state.copyWith(value: const AsyncValue.loading());
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        return authRepository.SignInWithEmailAndPassword(email, password);

      case EmailPasswordSignInFormType.register:
        return authRepository.CreateUserWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType Formtype) {
    state.copyWith(formType: Formtype);
  }
}

final emailPasswordSignInProvider = StateNotifierProvider.autoDispose.family<
    EmailPasswordSignInController,
    EmailPasswordSignInState,
    EmailPasswordSignInFormType>((ref, formType) {
  final authRepo = ref.watch(authRepositoryProvider);
  return EmailPasswordSignInController(
      authRepository: authRepo, formType: formType);
});
