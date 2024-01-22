import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/error/failure.dart';
import '../../../common/data/model/user_model.dart';
import '../../../common/domain/entity/user_entity.dart';
import "package:either_dart/either.dart";

abstract class AuthFbDataSource {
  Future<Either<Failure, UserEntity>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> getUser({required String uid});

  Future<Failure?> signOutUser();
}

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _firebaseDatabase;

  AuthFbDataSourceImpl(this._firebaseAuth, this._firebaseDatabase);

  @override
  Future<Either<Failure, UserEntity>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return await getUser(uid: credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(message: e.message.toString()));
    } catch (e) {
      log("Error [loginUser] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser({required String uid}) async {
    UserModel? user;
    try {
      await _firebaseDatabase.ref("new_db/users/$uid").once().then((value) {
        if (value.snapshot.exists) {
          user = UserModel.fromFirebase(value.snapshot.child("user_info"));
        }
      });
      if (user != null) {
        return Right(user!);
      } else {
        return Left(
            Failure(message: "Unable to retrieve user data. Try again"));
      }
    } catch (e) {
      log("Error [loginUser] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Failure?> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return null;
    } catch (e) {
      return Failure(message: "Something went wrong. Try again");
    }
  }
}
