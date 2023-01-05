// import 'package:firebase_auth/firebase_auth.dart';

// final _auth = FirebaseAuth.instance;

// void signInWithPhoneNumber(String phone,
//     {required Function(String value, int? value1) onCodeSent,
//     required Function(PhoneAuthCredential value) onAutoVerify,
//     required Function(FirebaseAuthException value) onFaild,
//     required Function(String value) autoRetrival}) async {
//   _auth.verifyPhoneNumber(
//       timeout: const Duration(seconds: 60),
//       phoneNumber: phone,
//       verificationCompleted: onAutoVerify,
//       verificationFailed: onFaild,
//       codeSent: onCodeSent,
//       codeAutoRetrievalTimeout: autoRetrival);
// }

// Future validateOtp(String smsCode, String verificationId) async {
//   final _credential = PhoneAuthProvider.credential(
//       verificationId: verificationId, smsCode: smsCode);
//   await _auth.signInWithCredential(_credential);
//   return;
// }

// Future<void> disconnect() async {
//   _auth.signOut();
// }
