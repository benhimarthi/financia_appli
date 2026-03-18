import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/auth/presentation/widgets/auth_scaffold.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      formKey: _formKey,
      title: '',//'Change Password',
      fields: [
        Text(
          "Change Password",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, ),
        ),
        const SizedBox(height: 20),
        Text(
          "We will send you a link to your email to reset your password.",
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Enter your email',
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.primary)
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
      ],
      submitButtonText: 'Send Reset Link',
      onSubmit: () {
        if (_formKey.currentState!.validate()) {
          context.read<AuthCubit>().forgotPassword(_emailController.text);
        }
      },
      switchButtonText: '',
      onSwitch: () {},
    );
  }
}
