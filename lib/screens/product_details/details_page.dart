import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/models/product.dart';
import 'package:flutter101/services/analytics_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class DetailsPage extends StatelessWidget {
  final String productUid;
  final Product product;

  const DetailsPage({Key? key, required this.product, required this.productUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseCrashlytics.instance.crash();
    var size = MediaQuery.of(context).size;
    String uid = Provider.of<User>(context, listen: false).uid;
    final Color color = Color(product.color);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        backgroundColor: color,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.4),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: kDefaultPaddin,
                      right: kDefaultPaddin,
                    ),
                    // height: 500,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          height: 100,
                          child: Text(product.description),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddin),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    right: kDefaultPaddin),
                                height: 50,
                                width: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: color,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.shopping_cart),
                                  onPressed: () async {
                                    context
                                        .read<FireStoreService>()
                                        .addToCart(uid, productUid)
                                        .then((value) => const CustomSnackBar(
                                              seconds: 4,
                                              type: '',
                                              text: 'product added to the cart',
                                            ).show(context))
                                        .catchError(
                                            (error) => const CustomSnackBar(
                                                  seconds: 4,
                                                  type: 'error',
                                                  text:
                                                      'some error occured try again.',
                                                ).show(context));
                                    await context
                                        .read<Analytics>()
                                        .logEvent("some_custom_event");

                                    await context
                                        .read<Analytics>()
                                        .logAddToCartEvent(
                                            productUid,
                                            product.title,
                                            product.category,
                                            product.price.toDouble());
                                  },
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: color,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Buy  Now".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Aristocratic Hand Bag",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: kDefaultPaddin),
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(text: "Price\n"),
                                  TextSpan(
                                    text: "\$${product.price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: kDefaultPaddin),
                            Hero(
                              tag: product.id,
                              child: Container(
                                width: 250,
                                height: 250,
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }
}
