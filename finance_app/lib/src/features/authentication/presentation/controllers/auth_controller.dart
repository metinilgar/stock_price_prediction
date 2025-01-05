import 'package:finance_app/src/features/authentication/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final userCredential = await authRepository.signIn(
          email: email,
          password: password,
        );
        return userCredential.user;
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final userCredential = await authRepository.signUp(
          email: email,
          password: password,
          name: name,
        );
        return FirebaseAuth.instance.currentUser;
      },
    );
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        await authRepository.signOut();
        return null;
      },
    );
  }
}
