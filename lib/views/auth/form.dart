import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController? name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController? rePassword;

  const AuthForm({
    super.key,
    this.name,
    required this.email,
    required this.password,
    this.rePassword,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (name != null)
              TextFormField(
                controller: name,
                validator: nameValidator,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
            if (name != null) 24.h,
            TextFormField(
              controller: email,
              validator: emailValidator,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            24.h,
            TextFormField(
              controller: password,
              validator: passwordValidator,
              keyboardType: TextInputType.visiblePassword,
              autofillHints: [
                rePassword != null
                    ? AutofillHints.newPassword
                    : AutofillHints.password
              ],
              decoration: const InputDecoration(
                hintText: 'Enter Your Password',
              ),
            ),
            if (rePassword != null) 24.h,
            if (rePassword != null)
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.newPassword],
                validator: rePasswordValidator,
                controller: rePassword,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? passwordValidator(String? value) {
    if ((value?.length ?? 0) > 5) return null;
    return 'Weak password, minimum length 6';
  }

  String? emailValidator(String? value) {
    var regExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (regExp.hasMatch(value ?? '')) return null;
    return 'Invalid Email Format';
  }

  String? rePasswordValidator(String? value) {
    if ((value?.length ?? 0) > 5) {
      if (password.text == value) return null;
      return 'Password do not match!';
    }
    return 'Weak password, minimum length 6';
  }

  String? nameValidator(String? value) {
    if (value?.trim().isNotEmpty ?? false) return null;
    return 'Please provide a real name';
  }
}
