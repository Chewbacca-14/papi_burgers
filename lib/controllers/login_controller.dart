import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  String verificationID = '';

  Future<LoginResult> sentVerifyCode(String phoneNumber) async {
    Completer<LoginResult> completer = Completer();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        log('Verification Completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.complete(LoginResult.error);
        log(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationID = verificationId;
        completer.complete(LoginResult.success);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('codeAutoRetrievalTimeout');
      },
    );
    notifyListeners();
    return completer.future;
  }

  Future<LoginCodeResult> checkOTPCode(String otpCode) async {
    Completer<LoginCodeResult> completer = Completer();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otpCode);

      // Sign the user in (or link) with the credential
      // ignore: unused_local_variable
      UserCredential signIn =
          await FirebaseAuth.instance.signInWithCredential(credential);
      completer.complete(LoginCodeResult.success);
    } catch (e) {
      completer.complete(LoginCodeResult.wrongOTP);
    }
    return completer.future;
  }
}

enum LoginResult {
  waiting,
  success,
  error,
  timeout,
}

enum LoginCodeResult {
  success,
  wrongOTP,
}
