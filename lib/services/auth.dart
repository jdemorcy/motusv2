
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoggedIn = false;

  // create user object based on Firebase user
  /*
  BrewUser? _userFromFirebaseUser(user) {
    return user != null ? BrewUser(uid: user.uid) : null;
  }
  */

  // listening to user auth event (log in / log out)
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // sign in anon
  Future signInAnon() async {

    try {
      isLoggedIn = true;
      notifyListeners();
      UserCredential result = await _auth.signInAnonymously();
      var user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and pwd
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and pwd
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // Create a new document for the user with the uid
      //await DatabaseService(uid: user!.uid).updateUserData('0', 'new crew member', 100);
      //return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      isLoggedIn = false;
      notifyListeners();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
