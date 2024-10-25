import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:astrum_test_app/services/auth/bloc/auth_bloc.dart';
import 'package:astrum_test_app/views/auth/form.dart';
import 'package:astrum_test_app/views/auth/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNewAccountView extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const CreateNewAccountView(),
    );
  }

  const CreateNewAccountView({super.key});

  @override
  State<CreateNewAccountView> createState() => _CreateNewAccountViewState();
}

class _CreateNewAccountViewState extends State<CreateNewAccountView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _rePassword;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _rePassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _rePassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthForm(
              name: _name,
              email: _email,
              password: _password,
              rePassword: _rePassword,
              formKey: _formKey,
            ),
            const Spacer(flex: 1),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<AuthBloc>().add(AuthEventSignUp(
                        name: _name.text,
                        email: _email.text,
                        password: _password.text,
                      ));
                }
              },
              child: const Text('Sign Up'),
            ),
            const Spacer(flex: 2),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(children: [
                const TextSpan(text: 'Already have an account? '),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushReplacement(
                          context,
                          SignInView.route(),
                        ),
                  text: 'Sign In',
                  style: const TextStyle(color: Colors.amber),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            24.h,
          ],
        ),
      ),
    );
  }
}
