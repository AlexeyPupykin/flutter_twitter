import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/models/failures/disable_user_failure.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class AuthRepo {
  AuthRepo({
    CacheClient? cache,
    firebase.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  User get currentUser {
    return _cache.read(key: userCacheKey) ?? User.empty;
  }

  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      var signedInCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return signedInCredentials.user!.toUser;
    } on firebase.FirebaseAuthException catch (ex) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(ex.code);
    } catch (ex) {
      throw SignUpWithEmailAndPasswordFailure(ex.toString());
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase.FirebaseAuthException catch (ex) {
      throw LogInWithEmailAndPasswordFailure.fromCode(ex.code);
    } catch (ex) {
      throw LogInWithEmailAndPasswordFailure(ex.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (ex) {
      throw LogOutFailure(ex.toString());
    }
  }

  Future<void> disableUser() async {
    try {
      await _firebaseAuth.currentUser!.delete();
      await logOut();
    } catch (ex) {
      print(ex.toString());
      throw DisableUserFailure(ex.toString());
    }
  }
}

extension on firebase.User {
  User get toUser {
    return User(
        uid: uid,
        email: email,
        username: email!.split("@")[0],
        displayName: displayName,
        photo: photoURL);
  }
}
