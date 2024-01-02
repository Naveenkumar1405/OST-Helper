import 'package:firebase_database/firebase_database.dart';
import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.profileUrl,
  });

  factory UserModel.fromEntity(UserEntity user) => UserModel(
        uid: user.uid,
        name: user.name,
        email: user.email,
        profileUrl: user.profileUrl,
      );

  factory UserModel.fromFirebase(DataSnapshot userData) {
    final info = userData.value as Map<Object?, Object?>;
    return UserModel(
        uid: userData.key.toString(),
        name: info["name"].toString(),
        email: info["email"].toString(),
        profileUrl: info["photoUrl"]?.toString() ?? "");
  }
}
