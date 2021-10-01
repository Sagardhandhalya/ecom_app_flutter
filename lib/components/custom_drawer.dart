import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/screens/Home/home.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = context.watch<User>();
    final username = currentUser?.displayName ?? "User Name";
    final photoUrl = currentUser?.photoURL ?? "";

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                accountName: Text(username),
                accountEmail: Text('${currentUser?.email}'),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/demo_avtar.png'),
                ),
              )),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('My orders'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('About Us'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await context.read<AuthService>().logOut();
            },
          ),
        ],
      ),
    );
  }
}
