import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../features/auth/data/data_source/auth_fb_data_source.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/auth/domain/use_case/auth_use_case.dart';
import '../../features/auth/presentation/provider/authentication_provider.dart';
import '../../features/home/data/home_fb_data_source.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  // **************************** Providers ****************************************

  sl.registerFactory<AuthenticationProvider>(
    () => AuthenticationProvider(sl.call()),
  );

  // **************************** UseCases **********************************

  /// AUTH
  sl.registerLazySingleton<AuthUseCase>(
    () => AuthUseCase(sl.call()),
  );

  // **************************** Repo **********************************

  /// AUTH
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(sl.call(), sl.call()),
  );

  // *********************** Remote Data Sources ******************************
  sl.registerLazySingleton<AuthFbDataSource>(
    () => AuthFbDataSourceImpl(sl.call(), sl.call()),
  );

  // ************************* External *********************************
  final auth = FirebaseAuth.instance;
  final db = FirebaseDatabase.instance;
  final ic = InternetConnectionChecker();

  sl.registerLazySingleton<FirebaseAuth>(() => auth);
  sl.registerLazySingleton<FirebaseDatabase>(() => db);
  sl.registerLazySingleton<InternetConnectionChecker>(() => ic);

  sl.registerLazySingleton<HomeFbDataSource>(
    () => HomeFbDataSource(
      sl.call(),
      sl.call(),
      sl.call(),
    ),
  );
}
