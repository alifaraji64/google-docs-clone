import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/repository/auth.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  void signInWithGoogle(WidgetRef ref) {
    print('hello');
    ref.read(authProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_search),
        onPressed: () {},
      ),
      body: Center(
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => signInWithGoogle(ref),
              icon: Image.asset(
                'google-logo.png',
                width: 20,
              ),
              label: const Text(
                'sign in with google',
                style: TextStyle(color: Colors.black),
              ))),
    );
  }
}
