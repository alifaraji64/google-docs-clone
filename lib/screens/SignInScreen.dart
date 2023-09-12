import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/error.dart';
import 'package:google_docs_clone/repository/auth.dart';
import 'package:google_docs_clone/screens/HomeScreen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessanger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);

    ErrorModel error = await ref.read(authProvider).signInWithGoogle();
    print(error.isError);
    if (error.isError) {
      return sMessanger.showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red[600],
      ));
    }
    return navigator.push('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_search),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final String? jwt = preferences.getString('jwt');
          print(jwt);
        },
      ),
      body: Center(
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => signInWithGoogle(ref, context),
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
