import 'package:flutter/foundation.dart';
import '../../../../core/error/failure.dart';
import '../../../common/domain/entity/user_entity.dart';
import '../../domain/use_case/auth_use_case.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthUseCase _authUseCase;

  AuthenticationProvider(this._authUseCase);

  UserEntity? _user;

  UserEntity? get user => _user;

  set user(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  Future<Failure?> loginUser({
    required String email,
    required String password,
  }) async {
    final response =
        await _authUseCase.loginUser(email: email, password: password);
    if (response.isRight) {
      user = response.right;
      return null;
    }
    return response.left;
  }

  Future<Failure?> getUser({required String uid}) async {
    final response = await _authUseCase.getUser(uid: uid);
    if (response.isRight) {
      user = response.right;
      return null;
    }
    return response.left;
  }

  Future<Failure?> signOutUser() async {
    final response = await _authUseCase.signOutUser();
    if (response != null) {
      return response;
    }
    user = null;
    return null;
  }
}
