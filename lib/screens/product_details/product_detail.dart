import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/constant.dart';
import 'package:flutter101/models/cart.dart';
import 'package:flutter101/models/product.dart';
import 'package:flutter101/services/analytics_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  final String productUid;
  final Product product;

  const ProductDetail(
      {Key? key, required this.productUid, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String uid = Provider.of<User>(context, listen: false).uid;
    final Color color = Color(product.color);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add_shopping_cart_outlined,
          size: 30,
        ),
        backgroundColor: color,
        onPressed: () async {
          try {
            await context.read<CartData>().addToCart(product);
            const CustomSnackBar(
              seconds: 4,
              type: '',
              text: 'product added to the cart',
            ).show(context);
          } catch (e) {
            debugPrint(e.toString());
            const CustomSnackBar(
              seconds: 4,
              type: 'error',
              text: 'some error occured try again.',
            ).show(context);
          }

          await context.read<Analytics>().logEvent("some_custom_event");

          await context.read<Analytics>().logAddToCartEvent(productUid,
              product.title, product.category, product.price.toDouble());
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 5,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const Text(
                            "Aristocratic Hand Bag",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${product.price}',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const Text(
                            '\$',
                            style: TextStyle(fontSize: 23),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      product.description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
