// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/error.dart';
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

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(isError: false, message: '');
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
        } else if (res.statusCode == 409) {
          print(jsonDecode(res.body)['message']);
          error = ErrorModel(
              isError: true, message: jsonDecode(res.body)['message']);
        } else {
          error = ErrorModel(
              isError: true, message: 'unknown error occured while signing up');
        }
      }
    } catch (e) {
      error = ErrorModel(
          isError: true, message: 'unknown error occured while signing up');
      print(e);
    }
    print(error);
    return error;
  }
}

final authProvider = ChangeNotifierProvider<Auth>((ref) => Auth(
      googleSignIn: GoogleSignIn(
        scopes: ['email', 'profile'], // Add the necessary scopes.
      ),
    ));
