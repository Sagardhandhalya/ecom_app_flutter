import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "TODO",
              style: TextStyle(fontSize: 20),
            ),
            Divider(color: Colors.black),
            SizedBox(
              width: 30,
              height: 30,
            ),
            Text(
              "We will implement this side bar letter",
            )
          ],
        ),
      ),
    );
  }
}
