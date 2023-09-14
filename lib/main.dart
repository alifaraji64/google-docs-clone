import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/error.dart';
import 'package:google_docs_clone/repository/auth.dart';
import 'package:google_docs_clone/screens/DocumentScreen.dart';
import 'package:google_docs_clone/screens/HomeScreen.dart';
import 'package:google_docs_clone/screens/signInScreen.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
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
    final routes = user == null
        ? RouteMap(routes: {
            '/': (route) => const MaterialPage(child: SignInScreen()),
          })
        : RouteMap(routes: {
            '/': (route) => const MaterialPage(child: HomeScreen()),
            '/document/:id': (route) => MaterialPage(
                child: DocumentScreen(id: route.pathParameters['id'] ?? ''))
          });
    print("user $user");
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
        routeInformationParser: const RoutemasterParser()

        //home: user == null ? const SignInScreen() : const HomeScreen(),
        );
  }
}
