import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/error.dart';
import 'package:google_docs_clone/repository/auth.dart';
import 'package:google_docs_clone/screens/HomeScreen.dart';
import 'package:google_docs_clone/screens/signInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(child: MyApp(preferences: preferences)));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key, required SharedPreferences preferences})
      : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late ErrorModel error;
  String? jwt;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    error = await ref.read(authProvider).getUserData();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    jwt = preferences.getString('jwt');
    print(error);
    if (error.data) {
      ref.read(authProvider).updateUserProvider(error.data);
    }
    setState(() {}); // Trigger a rebuild after fetching data
  }

  @override
  Widget build(BuildContext context) {
    if (jwt == null) {
      // Handle the case where jwt is null, for example, show a loading indicator
      return const CircularProgressIndicator();
    } else if (jwt!.isEmpty) {
      return const HomeScreen();
    } else {
      return const SignInScreen();
    }
  }
}
