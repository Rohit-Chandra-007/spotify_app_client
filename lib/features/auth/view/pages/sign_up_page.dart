import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loaders.dart';
import 'package:client/features/auth/view/pages/sign_in_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../widgets/auth_gradient_button.dart' show AuthGradientButton;

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  /// Global key for the form.
  final _formKey = GlobalKey<FormState>();

  /// Controllers for text fields.
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Dispose the controllers when the widget is removed.
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if want to listen only one variable then
    final isLoading = ref.watch(
      authViewModelProvider.select((value) => value?.isLoading == true),
    );
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, "Welcome, ${data.name}");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (_) => false,
          );
        },
        error: (error, stackTrace) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const CircularLoader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Text(
                        "Sign Up.",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hint: 'Name',
                        controller: nameController,
                      ),
                      CustomTextFormField(
                        hint: 'Email',
                        controller: emailController,
                      ),
                      CustomTextFormField(
                        hint: 'Password',
                        obscureText: true,
                        controller: passwordController,
                      ),
                      AuthGradientButton(
                        labelText: 'Sign Up',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(authViewModelProvider.notifier)
                                .userSignUp(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: '''Already have an account? ''',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: ColorPallete.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
