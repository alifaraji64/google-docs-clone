import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String email;
  final String name;
  final String photoURL;
  final String uid;
  User({
    required this.email,
    required this.name,
    required this.photoURL,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'uid': uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      photoURL: map['photoURL'] as String,
      uid: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? email,
    String? name,
    String? photoURL,
    String? uid,
  }) {
    return User(
        email: email ?? this.email,
        name: name ?? this.name,
        photoURL: photoURL ?? this.photoURL,
        uid: uid ?? this.uid);
  }
}
