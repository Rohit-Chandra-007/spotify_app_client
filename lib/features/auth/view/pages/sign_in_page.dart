import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loaders.dart';
import 'package:client/features/auth/view/pages/sign_up_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../widgets/auth_gradient_button.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // global key used for form

  @override
  Widget build(BuildContext context) {
    // if want to listen only one variable then
    final isLoading = ref.watch(
      authViewModelProvider.select((value) => value?.isLoading == true),
    );

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, "Welcome back, ${data.name}");
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
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Text(
                        'Sign In. ',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hint: 'Email',
                        controller: _emailController,
                      ),

                      CustomTextFormField(
                        hint: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      AuthGradientButton(
                        labelText: 'Sign In',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(authViewModelProvider.notifier)
                                .login(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                          } else {
                            showSnackBar(context, 'missing fields');
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: '''Don't have an account? ''',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Sign Up',
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
