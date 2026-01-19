import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:myapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:myapp/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:myapp/features/home/presentation/pages/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          formKey: _formKey,
          title: 'sign_in_title'.tr(),
          fields: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'email_label'.tr(),
                hintText: 'email_hint'.tr(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(0, 158, 158, 158),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'password_label'.tr(),
                hintText: 'password_hint'.tr(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(0, 158, 158, 158),
                  ),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: Text('forgot_password'.tr()),
              ),
            ),
          ],
          submitButtonText: 'sign_in_button'.tr(),
          onSubmit: () {
            if (_formKey.currentState!.validate()) {
              
              context.read<AuthCubit>().signIn(
                email: _emailController.text,
                password: _passwordController.text,
              );
            }
          },
          switchButtonText: 'no_account_switch'.tr(),
          onSwitch: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
        );
      },
    );
  }
}
