import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/authentication_provider.dart';
import '../../../auth/presentation/view/login_screen.dart';
import 'profile_avatar.dart';

/// @author : Jibin K John
/// @date   : 02/01/2024
/// @time   : 12:55:18

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * .8,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Consumer<AuthenticationProvider>(builder: (ctx, authProvider, _) {
        if (authProvider.user == null) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                ProfileAvatar(
                  imageUrl: authProvider.user!.profileUrl,
                  radius: size.width * .4,
                ),
                const SizedBox(height: 20.0),
                Text(
                  authProvider.user!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  authProvider.user!.email,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            FilledButton(
                onPressed: () {
                  Provider.of<AuthenticationProvider>(context, listen: false)
                      .signOutUser()
                      .then((value) {
                    if (value == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const LoginScreen()));
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value.message)),
                      );
                    }
                  });
                },
                child: const Text("Logout"))
          ],
        );
      }),
    );
  }
}
