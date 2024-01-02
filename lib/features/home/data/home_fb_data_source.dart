import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../core/error/failure.dart';
import '../../auth/data/data_source/auth_fb_data_source.dart';
import '../../common/domain/entity/ost_user_entity.dart';

class HomeFbDataSource {
  final AuthFbDataSource _authFbDataSource;
  final FirebaseDatabase _firebaseDatabase;
  final InternetConnectionChecker _internetConnectionChecker;

  HomeFbDataSource(
    this._firebaseDatabase,
    this._internetConnectionChecker,
    this._authFbDataSource,
  );

  Future<Either<Failure, List<OSTUserEntity>>> getAllUsers() async {
    List<OSTUserEntity> users = [];
    if (await _internetConnectionChecker.hasConnection) {
      try {
        await _firebaseDatabase.ref("Homes").once().then((homes) async {
          if (homes.snapshot.exists) {
            for (final owner in homes.snapshot.children) {
              List<String> products = [];
              for (final home in owner.children) {
                for (final room in home.child("rooms").children) {
                  for (final product in room.child("products").children) {
                    products.add(product.key.toString());
                  }
                }
              }

              await _authFbDataSource
                  .getUser(uid: owner.key.toString())
                  .then((user) {
                if (user.isRight) {
                  users.add(
                    OSTUserEntity(
                      uid: user.right.uid,
                      name: user.right.name,
                      email: user.right.email,
                      profileUrl: user.right.profileUrl,
                      products: products,
                    ),
                  );
                }
              });
            }
          }
        });
        return Right(users);
      } catch (e) {
        log("Error [getAllUsers] $e");
        return Left(Failure(message: "Something went wrong. Try again"));
      }
    } else {
      return Left(Failure(message: "Check your network connection"));
    }
  }
}
