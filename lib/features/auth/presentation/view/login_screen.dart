import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/mixin/validation_mixin.dart';
import '../../../home/presentation/view/home_screen.dart';
import '../provider/authentication_provider.dart';

/// @author : im_navi

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  String _email = "";
  String _password = "";

  @override
  void dispose() {
    _isObscure.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            SvgPicture.asset("assets/svg/login.svg", height: size.height * .4),
            const Center(
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30.0),
              ),
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // EMAIL
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    onSaved: (value) => _email = value.toString().trim(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail_rounded),
                      prefixIconColor: MaterialStateColor.resolveWith(
                        (states) => states.contains(MaterialState.focused)
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      hintText: "Email",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14.0),
                      contentPadding: const EdgeInsets.all(15.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // PASSWORD
                  ValueListenableBuilder(
                    valueListenable: _isObscure,
                    builder: (_, obscure, __) {
                      return TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: validatePassword,
                        obscureText: obscure,
                        onSaved: (value) => _password = value.toString().trim(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_rounded),
                          prefixIconColor: MaterialStateColor.resolveWith(
                            (states) => states.contains(MaterialState.focused)
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _isObscure.value = !_isObscure.value;
                            },
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14.0),
                          contentPadding: const EdgeInsets.all(15.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 1, color: Colors.redAccent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            ValueListenableBuilder(
                valueListenable: _loading,
                builder: (_, loading, __) {
                  return FilledButton(
                    onPressed: loading
                        ? null
                        : () {
                            final authProvider =
                                Provider.of<AuthenticationProvider>(
                              context,
                              listen: false,
                            );
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _loading.value = true;
                              authProvider
                                  .loginUser(email: _email, password: _password)
                                  .then((response) {
                                _loading.value = false;
                                if (response == null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response.message)),
                                  );
                                }
                              });
                            }
                          },
                    child: Text(loading ? "Logging in" : "Login"),
                  );
                })
          ],
        ),
      ),
    );
  }
}
