import 'package:either_dart/either.dart';

import '../../../../core/error/failure.dart';
import '../../../common/domain/entity/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> loginUser({
    required String email,
    required String password,
  });

  Future<Failure?> signOutUser();

  Future<Either<Failure, UserEntity>> getUser({required String uid});
}
