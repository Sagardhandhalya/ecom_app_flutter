import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/modals/app_user.dart';
import 'package:flutter101/screens/Home/home.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<User>(context, listen: false).uid;
    //  'assets/images/demo_avtar.png';

    return Drawer(
        child: ListView(
      children: [
        FutureBuilder<AppUser>(
            future:
                Provider.of<FireStoreService>(context).getCurrentUserInfo(uid),
            builder: (context, currentUser) {
              // print(currentUser.data!.toJson());
              if (currentUser.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (currentUser.hasError) {
                return const Center(child: Text('failed to fetch data'));
              }
              return DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: UserAccountsDrawerHeader(
                    accountName: const Text(''),
                    accountEmail: Text(currentUser.data!.email),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/demo_avtar.png'),
                    ),
                  ));
            }),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () => {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()))
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
    ));
  }
}
