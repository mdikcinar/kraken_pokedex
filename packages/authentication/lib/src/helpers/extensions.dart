import 'package:authentication/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

extension FirebaseUserExtension on firebase_auth.User {
  User get toUser => User(id: uid, email: email, name: displayName, photo: photoURL);
}
