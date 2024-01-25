import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/error/failure.dart';
import '../../auth/data/data_source/auth_fb_data_source.dart';
import '../../common/data/model/user_model.dart';
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
    List<OSTUserEntity> usersList = [];
    if (await _internetConnectionChecker.hasConnection) {
      try {
        await _firebaseDatabase.ref("new_db/users").once().then((users) async {
          if (users.snapshot.exists) {
            for (final userData in users.snapshot.children) {
              bool hasAccessNode =
                  false; // Flag to check if "access" node is present
              bool hasHomesNode =
                  false; // Flag to check if "homes" node is present
              List<String> products = [];

              for (final home in userData.child("homes").children) {
                if (home.key == "access") {
                  hasAccessNode = true;
                  break;
                }

                hasHomesNode = true; // Set the flag if "homes" node is present

                for (final room in home.child("rooms").children) {
                  for (final product in room.child("products").children) {
                    products.add(product.key.toString());
                  }
                }
              }

              if (!hasAccessNode && hasHomesNode) {
                final user =
                    UserModel.fromFirebase(userData.child("user_info"));
                usersList.add(
                  OSTUserEntity(
                    uid: user.uid,
                    name: user.name,
                    email: user.email,
                    profileUrl: user.profileUrl,
                    products: products,
                  ),
                );
              }
            }
          }
        });
        return Right(usersList);
      } catch (e) {
        log("Error [getAllUsers] $e");
        return Left(Failure(message: "Something went wrong. Try again"));
      }
    } else {
      return Left(Failure(message: "Check your network connection"));
    }
  }
}
