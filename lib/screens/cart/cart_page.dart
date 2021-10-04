import 'package:flutter/material.dart';
import 'package:flutter101/components/custom_drawer.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Cart()));
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            tooltip: 'Go to cart page',
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Cart Page'),
      ),
    );
  }
}
