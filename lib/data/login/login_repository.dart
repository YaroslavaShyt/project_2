import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginRepository implements ILoginRepository {
  late FirebaseAuth _firebaseAuth;

  LoginRepository() {
    init();
  }

  void init() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Future sendOtp({required String phoneNumber}) async {
    await _firebaseAuth
        .verifyPhoneNumber(
            timeout: const Duration(seconds: 30),
            phoneNumber: "+38$phoneNumber",
            verificationCompleted: (phoneAuthCredential) async => {},
            verificationFailed: (error) {},
            codeSent: (verificationId, forceResendingToken) async =>
                verificationId,
            codeAutoRetrievalTimeout: (verificationId) async {})
        .onError((error, stackTrace) => error.toString());
  }

  @override
  Future loginOtp({required String otp}) async {
    //final cred = PhoneAuthProvider.credential(verificationId: , smsCode: smsCode)
  }
}
