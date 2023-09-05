import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  final GoogleSignIn _googleSignIn;
  String text = 'trrt';
  Auth({
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;

  Future<void> signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      print(user);
      if (user != null) {
        print(user.email);
        print(user.displayName);
        print(user.photoUrl);
      }
    } catch (e) {
      print(e);
    }
  }

  void changeText() {
    text = 'changed';
    print(text);
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<Auth>((ref) => Auth(
      googleSignIn: GoogleSignIn(
        scopes: ['email', 'profile'], // Add the necessary scopes.
      ),
    ));
