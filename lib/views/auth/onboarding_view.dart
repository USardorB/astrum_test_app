import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:astrum_test_app/services/auth/bloc/auth_bloc.dart';
import 'package:astrum_test_app/views/auth/create_new_account_view.dart';
import 'package:astrum_test_app/views/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 280,
                child: Icon(Icons.map, size: 110, color: Colors.amber),
              ),
              const ListTile(
                title: Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Mesure how much would you spend',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xffA0A0A0)),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CreateNewAccountView.route(),
                ),
                child: const Text('Create an account'),
              ),
              24.h,
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  SignInView.route(),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.amber),
                  ),
                  foregroundColor: Colors.amber,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
