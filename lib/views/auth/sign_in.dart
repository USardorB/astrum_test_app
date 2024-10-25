import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:astrum_test_app/services/auth/bloc/auth_bloc.dart';
import 'package:astrum_test_app/views/auth/create_new_account_view.dart';
import 'package:astrum_test_app/views/auth/form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) => const SignInView());
  }

  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthForm(
              email: _email,
              password: _password,
              formKey: _formKey,
            ),
            const Spacer(flex: 1),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<AuthBloc>().add(AuthEventSignIn(
                        email: _email.text,
                        password: _password.text,
                      ));
                }
              },
              child: const Text('Sign In'),
            ),
            24.h,
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(children: [
                const TextSpan(text: 'Don’t have an account? '),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushReplacement(
                          context,
                          CreateNewAccountView.route(),
                        ),
                  text: 'Sign Up',
                  style: const TextStyle(color: Colors.amber),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
