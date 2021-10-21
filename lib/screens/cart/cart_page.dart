import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/models/product.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Stream<AppUser?>? _pStream;

  String? uid;

  Stream<AppUser?> _getCartProductSteam(BuildContext context) {
    uid ??= Provider.of<User?>(context, listen: false)?.uid;
    return _pStream ??=
        Provider.of<FireStoreService>(context).getCurrentUserInfo(uid!);
  }

  Stream<Product?> fetchProduct(String id, BuildContext context) {
    return Provider.of<FireStoreService>(context).getProductFromId(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'cart page',
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: StreamBuilder<AppUser?>(
          stream: _getCartProductSteam(context),
          builder: (BuildContext context, AsyncSnapshot<AppUser?> snapshot) {
            if (snapshot.hasError) {
              return const CustomSnackBar(
                  seconds: 2, text: 'not able to fetch data', type: 'error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Text('Nothing to show');
            }

            AppUser userData = snapshot.data!;

            List<String> keyArr = userData.cart.keys.toList();
            List<int> valArr = userData.cart.values.toList();

            return Column(
              children: [
                ListView.builder(
                    itemCount: keyArr.length,
                    padding: const EdgeInsets.all(5.0),
                    itemBuilder: (context, i) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          Provider.of<FireStoreService>(context, listen: false)
                              .deleteFromTheCart(
                                  uid!, userData.cart.keys.toList()[i]);
                          const CustomSnackBar(
                                  seconds: 4,
                                  text: 'Item deleted',
                                  type: 'success')
                              .show(context);
                        },
                        background: Container(color: Colors.red),
                        child: Container(
                          margin: const EdgeInsets.all(9),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder<Product?>(
                                stream: fetchProduct(keyArr[i], context),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.data != null) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(
                                          snapshot.data!.image,
                                          width: 100,
                                          height: 100,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              snapshot.data!.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Provider.of<FireStoreService>(
                                                              context,
                                                              listen: false)
                                                          .updateQty(
                                                              uid!,
                                                              keyArr[i],
                                                              true,
                                                              valArr[i]);
                                                    },
                                                    icon: const Icon(
                                                      Icons.add,
                                                    )),
                                                Text(
                                                  '${valArr[i]}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Provider.of<FireStoreService>(
                                                              context,
                                                              listen: false)
                                                          .updateQty(
                                                              uid!,
                                                              keyArr[i],
                                                              false,
                                                              valArr[i]);
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove))
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\$ ${snapshot.data!.price * (valArr[i])}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Provider.of<FireStoreService>(
                                                            context,
                                                            listen: false)
                                                        .deleteFromTheCart(
                                                            uid!,
                                                            userData.cart.keys
                                                                .toList()[i]);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                            ])
                                      ],
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5)),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          }),
    );
  }
}
