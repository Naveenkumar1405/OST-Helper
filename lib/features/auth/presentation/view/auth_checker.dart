import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/view/home_screen.dart';
import '../provider/authentication_provider.dart';
import 'auth_error_screen.dart';
import 'login_screen.dart';

/// @author : Jibin K John
/// @date   : 02/01/2024
/// @time   : 10:32:16

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final ValueNotifier<bool> _loading = ValueNotifier(true);
  final ValueNotifier<Widget?> _screen = ValueNotifier(null);

  @override
  void didChangeDependencies() {
    _initUser();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _loading.dispose();
    _screen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loading,
      builder: (_, loading, __) {
        return ValueListenableBuilder(
            valueListenable: _screen,
            builder: (_, screen, __) {
              if (!loading && screen != null) {
                return screen;
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            });
      },
    );
  }

  Future<void> _initUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _loading.value = true;
    if (user != null) {
      final context = this.context;
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final response = await authProvider.getUser(uid: user.uid);
      if (response != null) {
        _screen.value = AuthErrorScreen(
          error: response.message,
          onRetry: _initUser,
        );
      } else {
        _screen.value = const HomeScreen();
      }
    } else {
      _screen.value = const LoginScreen();
    }
    _loading.value = false;
  }
}
