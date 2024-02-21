import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginRepository implements ILoginRepository {
  final FirebaseAuth _firebaseAuth;
  String verifId = '';

  LoginRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  @override
  Future sendOtp({required String phoneNumber}) async {
    await _firebaseAuth.verifyPhoneNumber(
        timeout: const Duration(seconds: 30),
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async => {},
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) async => {
              print(verificationId),
              verifId = verificationId,
            },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  @override
  Future loginOtp({required String otp}) async {
    if (verifId.isNotEmpty) {
      final cred =
          PhoneAuthProvider.credential(verificationId: verifId, smsCode: otp);
      await _firebaseAuth.signInWithCredential(cred);
    }
  }

  @override
  Future logout() async {
    await _firebaseAuth.signOut();
  }
}
