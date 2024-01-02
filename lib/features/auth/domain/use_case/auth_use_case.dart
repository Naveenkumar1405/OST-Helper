import 'package:either_dart/either.dart';

import '../../../../core/error/failure.dart';
import '../../../common/domain/entity/user_entity.dart';
import '../repo/auth_repo.dart';

class AuthUseCase {
  final AuthRepo _authRepo;

  AuthUseCase(this._authRepo);

  Future<Either<Failure, UserEntity>> loginUser({
    required String email,
    required String password,
  }) async =>
      await _authRepo.loginUser(email: email, password: password);

  Future<Either<Failure, UserEntity>> getUser({required String uid}) async =>
      await _authRepo.getUser(uid: uid);

  Future<Failure?> signOutUser() async => await _authRepo.signOutUser();
}
