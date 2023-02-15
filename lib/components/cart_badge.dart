import 'package:badges/badges.dart' as bgs;
import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    Key? key,
    required this.cartCount,
  }) : super(key: key);

  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return bgs.Badge(
      // animationType: bgs.BadgeAnimationType.scale,
      // badgeColor: Colors.purple,
      position: bgs.BadgePosition.topEnd(top: 0, end: 2),
      badgeContent: Text(cartCount > 9 ? '9+' : cartCount.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 10)),
      child: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, 'cart_page');
        },
        icon: const Icon(
          Icons.shopping_cart_outlined,
        ),
        tooltip: 'Go to cart page',
      ),
    );
  }
}
