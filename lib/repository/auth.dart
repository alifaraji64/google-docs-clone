// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/models/error.dart';
import 'package:google_docs_clone/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Auth extends ChangeNotifier {
  final GoogleSignIn _googleSignIn;
  User? userProvider;
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
            uid: '');

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
          newUser = newUser.copyWith(
            uid: jsonDecode(res.body)['user']['_id'],
          );
          updateUserProvider(newUser);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(
            'jwt',
            jsonDecode(res.body)['jwt'],
          );
          return error = ErrorModel(isError: false, message: '');
        }
        error = handleResponseError(res: res, error: error);
      }
    } catch (e) {
      error = ErrorModel(
          isError: true, message: 'unknown error occured while signing up');
      print('fsdf');
      print(e);
    }
    print(error);
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(isError: false, message: '');
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final String? jwt = preferences.getString('jwt');
      if (jwt == null) {
        error = ErrorModel(
          isError: true,
          message: 'jwt is empty is shared preferences',
        );
        return error;
      }
      print("jwt $jwt");
      http.Response res = await http.get(
        Uri.parse('$uri/user-data'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'jwt': jwt
        },
      );
      if (res.statusCode == 200) {
        final user = User.fromJson(jsonEncode(jsonDecode(res.body)['user']));
        updateUserProvider(user);
        error = ErrorModel(isError: false, message: '', data: user);
        return error;
      }
      error = handleResponseError(res: res, error: error);
    } catch (e) {
      error = ErrorModel(
          isError: true,
          message: 'unkown error occured while getting the user data');
    }
    return error;
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('jwt');
    await _googleSignIn.signOut();
    updateUserProvider(null);
  }

  updateUserProvider(User? user) {
    userProvider = user;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<Auth>((ref) => Auth(
      googleSignIn: GoogleSignIn(
        scopes: ['email', 'profile'], // Add the necessary scopes.
      ),
    ));
