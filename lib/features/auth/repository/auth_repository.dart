import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_management_app/core/utils/app_exception.dart';
import 'package:project_management_app/core/utils/debug_prints.dart';
import 'package:project_management_app/features/auth/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<AppException, UserModel?>> loginWithEmail(
      String email, String password);

  Future<Either<AppException, UserModel?>> registerWithEmail(
      String fullName, String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  Future<Either<AppException, UserModel?>> loginWithEmail(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        return Left(AppException(errorMessage: "invalid email or password"));
      }
      final res = await _databaseReference
          .child("users")
          .child(userCredential.user!.uid)
          .get();
      UserModel userModel = UserModel.fromJson(res.value);
      return Right(userModel);
    } on FirebaseException catch (e) {
      printInfo("CODE ${e.code}");
      switch (e.code) {
        case 'invalid-email':
          printError('Invalid email.');
          return Left(AppException(errorMessage: "Invalid email."));
        case 'user-disabled':
          printError('User disabled.');
          return Left(AppException(errorMessage: "User disabled."));
        case 'user-not-found' || 'invalid-credential':
          printError('User not found.');
          return Left(AppException(errorMessage: "User not found."));
        case 'wrong-password':
          printError('Wrong password.');
          return Left(AppException(errorMessage: "Wrong password."));
        default:
          printError('An unknown error occurred.');
          return Left(AppException(errorMessage: "An unknown error occurred."));
      }
    } catch (e) {
      printError('Error during login: $e');
      return Left(AppException(errorMessage: "Error during login: $e"));
    }
  }

  @override
  Future<Either<AppException, UserModel?>> registerWithEmail(
      String fullName, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _databaseReference.child('users').child(user.uid).set({
          'id': user.uid,
          'fullName': fullName,
          'email': email,
        });
      } else {
        return Left(AppException(errorMessage: "Invalid User Data"));
      }
      UserModel userModel = UserModel(
        id: user.uid,
        fullName: fullName,
        email: email,
      );
      return Right(userModel);
    } on FirebaseException catch (e) {
      printInfo("CODE ${e.code}");
      switch (e.code) {
        case 'weak-password':
          printError('Password length must be at least 6 Characters.');
          return Left(AppException(
              errorMessage: "Password length must be at least 6 Characters."));
        case 'invalid-email':
          printError('Invalid email.');
          return Left(AppException(errorMessage: "Invalid email."));
        case 'user-disabled':
          printError('User disabled.');
          return Left(AppException(errorMessage: "User disabled."));
        case 'user-not-found' || 'invalid-credential':
          printError('User not found.');
          return Left(AppException(errorMessage: "User not found."));
        case 'wrong-password':
          printError('Wrong password.');
          return Left(AppException(errorMessage: "Wrong password."));
        default:
          printError('An unknown error occurred.');
          return Left(AppException(errorMessage: "An unknown error occurred."));
      }
    } catch (e) {
      printError('Error during registration: $e');
      return Left(AppException(errorMessage: "Error during registration: $e"));
    }
  }
}
