import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginRepository implements ILoginRepository {
  late FirebaseAuth _firebaseAuth;

  @override
  Future sendOtp({required String phoneNumber}) async {
    await _firebaseAuth
        .verifyPhoneNumber(
            timeout: const Duration(seconds: 30),
            phoneNumber: phoneNumber,
            verificationCompleted: (phoneAuthCredential) async => {},
            verificationFailed: (error) {},
            codeSent: (verificationId, forceResendingToken) async =>
                verificationId,
            codeAutoRetrievalTimeout: (verificationId) async {})
        .onError((error, stackTrace) => error.toString());
  }

  @override
  Future loginOtp({required String otp, required String verifyID}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyID, smsCode: otp);
    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future logout() async{
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async{
    var user = _firebaseAuth.currentUser;
    return user != null;
  }
}
