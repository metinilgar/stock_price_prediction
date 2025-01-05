import 'package:finance_app/src/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:finance_app/src/features/authentication/presentation/controllers/validation_controller.dart';
import 'package:finance_app/src/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:finance_app/src/utils/extensions/async_value_ui.dart';
import 'package:finance_app/src/features/navigation_menu/presentation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final validation = ref.read(validationControllerProvider.notifier);
    String? email;
    String? password;
    String? name;

    ref.listen<AsyncValue>(authControllerProvider, (previous, next) {
      // Hata durumunda dialog göster
      next.showAlertDialogOnError(context);

      // Başarılı durumda ve kullanıcı varsa ana sayfaya yönlendir
      if (!next.isLoading && !next.hasError && next.hasValue) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const NavigationMenu(),
          ),
          (route) => false,
        );
      }
    });

    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Text for sign up
                Text(
                  "SIGN UP",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 40),

                // TextFormField for email
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => validation.nameValidation(value),
                  onSaved: (value) => name = value,
                ),
                const SizedBox(height: 20),

                // TextFormField for password
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) => validation.emailValidation(value),
                  onSaved: (value) => email = value,
                ),
                const SizedBox(height: 20),

                // TextFormField for confirm password
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) => validation.passwordValidation(value),
                  onSaved: (value) => password = value,
                ),
                const SizedBox(height: 10),

                // TextButton for sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                        (route) => false,
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 0),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(
                        'Sign in here.',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ElevatedButton for sign up
                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authControllerProvider);
                    return ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                ref
                                    .read(authControllerProvider.notifier)
                                    .signUp(
                                      email: email!,
                                      password: password!,
                                      name: name!,
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 50),
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'SIGN UP',
                              style: TextStyle(fontSize: 20),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
