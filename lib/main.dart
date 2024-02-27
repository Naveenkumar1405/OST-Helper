import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/provider/authentication_provider.dart';
import 'features/auth/presentation/view/auth_checker.dart';
import 'features/mqtt/presentation/provider/mqtt_provider.dart';
import 'features/mqtt/presentation/view/connection_screen.dart';
import 'features/mqtt/presentation/view/home_screen2.dart';
import 'firebase_options.dart';
import 'core/config/injection_container.dart' as di;

//author : Navin_N

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.initInjections();
  await _setPreferredOrientations();
  runApp(MyApp());
}

Future<void> _setPreferredOrientations() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthenticationProvider>()),
        ChangeNotifierProvider(create: (_) => MQTTProvider()),
      ],
      child: MaterialApp(
        title: 'OST Helper',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: AuthChecker(), // Initially check authentication status
        routes: {
          '/home': (_) => const HomeScreen(),
          '/connect': (_) => const ConnectionScreen(),
        },
      ),
    );
  }
}
