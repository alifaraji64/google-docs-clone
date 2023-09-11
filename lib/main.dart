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
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late ErrorModel error;
  String? jwt;

  @override
  void initState() {
    super.initState();
    Timer(Duration.zero, () {
      getUserData();
    });
  }

  Future<void> getUserData() async {
    try {
      error = await ref.read(authProvider).getUserData();
      print('message: ' + error.message);
      if (error.data != null) {
        ref.read(authProvider).updateUserProvider(error.data);
      }
    } catch (e) {
      print('bam');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).userProvider;
    print("user $user");
    return MaterialApp(
      home: user == null ? const SignInScreen() : const HomeScreen(),
    );
  }
}
