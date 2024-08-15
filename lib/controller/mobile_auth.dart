import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PhoneOtpAuth extends ChangeNotifier {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static String verifyId = "";
  int remainingTime = 59;
  Timer? _timer;

  void startTimer() {
    remainingTime = 59;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        _timer?.cancel();
      } else {
        remainingTime--;
        notifyListeners();
      }
    });
  }

  void resendOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await sentOtp(phone: phone, errorStep: errorStep, nextStep: nextStep);
    startTimer();
  }

  Future<void> sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        timeout: Duration(seconds: 59),
        phoneNumber: "+91$phone",
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (error) {
          print('Verification failed: ${error.message}');
          errorStep();
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          print('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      print('Exception caught: $e');
      errorStep();
    }
  }

  Future<String> loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await auth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "User sign-in failed";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
