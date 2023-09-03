import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {},
              icon: Image.asset(
                'google-logo.png',
                width: 20,
              ),
              label: const Text(
                'sign in with google 8',
                style: TextStyle(color: Colors.black),
              ))),
    );
  }
}
