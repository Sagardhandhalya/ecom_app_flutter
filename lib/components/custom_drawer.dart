import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/screens/Home/home.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:flutter101/services/firebase_storage_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<User?>(context, listen: false)!.uid;

    return Drawer(
        child: ListView(
      children: [
        StreamBuilder<AppUser?>(
            stream:
                Provider.of<FireStoreService>(context).getCurrentUserInfo(uid),
            builder: (context, currentUser) {
              if (currentUser.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (currentUser.hasError || currentUser.data == null) {
                return const Center(child: Text('failed to fetch data'));
              }
              String photoUrl = currentUser.data!.photoURL ??
                  'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-demo-c5029.appspot.com/o/profilePhotos%2FN8xzsP5bB7ZGSsiuDOHcBLqHbG43.png?alt=media&token=f7d27795-68c6-484e-9fc5-db1cf906d6d6';
              return DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: UserAccountsDrawerHeader(
                      accountName: Text(currentUser.data!.fullName),
                      accountEmail: Text(currentUser.data!.email),
                      currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl))));
            }),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Profile'),
          onTap: () {
            Navigator.pushNamed(context, 'profile_page');
          },
        ),
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
            Navigator.pop(context);
            Navigator.popAndPushNamed(context, '/');
          },
        ),
      ],
    ));
  }
}
