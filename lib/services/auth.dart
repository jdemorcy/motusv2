
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motusv2/model/motus_user.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late MotusUser? _user;
  var isLoggedIn = false;

  AuthService() {
    _init();
  }

  void _init() {
    _user = MotusUser(uid: null);
  }

  // create user object based on Firebase user
  MotusUser? _userFromFirebaseUser(user) {
    return user != null ? MotusUser(uid: user.uid) : null;
  }
  
  MotusUser? get user {
    return _user;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      _user = _userFromFirebaseUser(result.user);
      isLoggedIn = true;
      notifyListeners();
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
      _user = _userFromFirebaseUser(result.user);
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
      _init();
      notifyListeners();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
