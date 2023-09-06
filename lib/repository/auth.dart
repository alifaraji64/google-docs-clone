// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Auth extends ChangeNotifier {
  final GoogleSignIn _googleSignIn;
  late User userProvider;
  Auth({
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;

  Future<void> signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      print(user);
      if (user != null) {
        User newUser = User(
          email: user.email,
          name: user.displayName!,
          photoURL: user.photoUrl!,
          uid: '',
          token: '',
        );

        http.Response res = await http.post(
          Uri.parse('$uri/signup'),
          body: newUser.toJson(),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          },
        );
        if (res.statusCode == 200) {
          newUser = newUser.copyWith(uid: jsonDecode(res.body)['_id']);
          userProvider = newUser;
          return;
        }
        if (res.statusCode == 409) {
          print(jsonDecode(res.body)['message']);
          return;
        }
        print('unknown error occured');
      }
    } catch (e) {
      print('error');
      print(e);
    }
  }
}

final authProvider = ChangeNotifierProvider<Auth>((ref) => Auth(
      googleSignIn: GoogleSignIn(
        scopes: ['email', 'profile'], // Add the necessary scopes.
      ),
    ));
