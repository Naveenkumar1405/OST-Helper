import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/authentication_provider.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../mqtt/presentation/view/connection_screen.dart';
import '../../data/client_data.dart';
import '../view/client_screen.dart';
import 'profile_avatar.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Consumer<AuthenticationProvider>(
        builder: (ctx, authProvider, _) {
          if (authProvider.user == null) {
            return SizedBox.shrink();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ProfileAvatar(
                    imageUrl: authProvider.user!.profileUrl,
                    radius: size.width * 0.4,
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
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        var clientsData = await fetchClients();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientScreen(clients: clientsData),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text('Check Client Connections'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Background color
                      onPrimary: Colors.white, // Text color
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ConnectionScreen()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text('Mqtt Client Testing'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Background color
                      onPrimary: Colors.white, // Text color
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
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
                        builder: (_) => const LoginScreen(),
                      ));
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value.message)),
                      );
                    }
                  });
                },
                child: const Text("Logout"),
              )
            ],
          );
        },
      ),
    );
  }
}
