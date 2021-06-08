import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tech_pinterest/utils/exceptions.dart';


abstract class AuthenticationRepositoryInterface {
  Future<User?> signInWithGoogle({Function newUserHandler});
  Future<User?> signInWithCurrentUser();
  Future<void> signOut();
}

class AuthenticationRepository implements AuthenticationRepositoryInterface {
  AuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignin,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(scopes: <String>['email']) {
          initializeFirebase();
        }

  FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


   @override
  Future<User?> signInWithCurrentUser() async {
    final User ? firebaseUser =  _firebaseAuth.currentUser;
    print(firebaseUser);
    return firebaseUser;
  }


  @override
  Future<User?> signInWithGoogle({Function ? newUserHandler}) async {
    try {
      print("singin with google");
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return Future.value(null);
        //throw const AppException(code: 'ERROR_SiGN_IN_CANCEL');
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
      print(credential);

      final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = authResult.user;
      print(firebaseUser);
      return firebaseUser;
    } catch (exception) {
      await signOut();
      throw AppException.from(exception as Exception);
    }
  }


  @override
  Future<void> signOut() async {
    try {
        await Future.wait<void>(<Future<void>>[
          _firebaseAuth.signOut(),
          _googleSignIn.signOut(),
        ]);
    } catch (_) {}
  }

}

class AuthResult {
}
