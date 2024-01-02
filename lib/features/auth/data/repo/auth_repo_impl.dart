import 'package:either_dart/either.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../core/error/failure.dart';
import '../../../common/domain/entity/user_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/auth_fb_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthFbDataSource _authFbDataSource;
  final InternetConnectionChecker _connectionChecker;

  AuthRepoImpl(this._authFbDataSource, this._connectionChecker);

  @override
  Future<Either<Failure, UserEntity>> loginUser({
    required String email,
    required String password,
  }) async {
    if (await _connectionChecker.hasConnection) {
      return await _authFbDataSource.loginUser(
          email: email, password: password);
    } else {
      return Left(Failure(message: "Check your network connection"));
    }
  }



  @override
  Future<Either<Failure, UserEntity>> getUser({required String uid}) async {
    if (await _connectionChecker.hasConnection) {
      return await _authFbDataSource.getUser(uid: uid);
    } else {
      return Left(Failure(message: "Check your network connection"));
    }
  }

  @override
  Future<Failure?> signOutUser() async {
    if (await _connectionChecker.hasConnection) {
      return await _authFbDataSource.signOutUser();
    } else {
      return Failure(message: "Check your network connection");
    }
  }
}
