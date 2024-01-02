import 'package:flutter/material.dart';
import 'login_screen.dart';

/// @author : Jibin K John
/// @date   : 02/01/2024
/// @time   : 11:59:22

class AuthErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const AuthErrorScreen({Key? key, required this.error, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error),
              FilledButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Reset Session"))
            ],
          ),
        ),
      ),
    );
  }
}
