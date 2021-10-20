import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/custom_drawer.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/models/product.dart';
import 'package:flutter101/screens/login/login.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  Future<Product> fetchProduct(String id, BuildContext context) async {
    return Provider.of<FireStoreService>(context).getProductFromId(id);
  }

  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<User?>(context, listen: false)?.uid;
    return uid == null
        ? const Login()
        : Scaffold(
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
            body: StreamBuilder(
                stream:
                    Provider.of<FireStoreService>(context).getUsersCart(uid),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return const CustomSnackBar(
                        seconds: 4,
                        text: 'not able to fetch data',
                        type: 'error');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  AppUser userData = AppUser.fromDocument(
                      snapshot.data as DocumentSnapshot<Map<String, dynamic>>);

                  List<String> keyArr = userData.cart.keys.toList();
                  List<int> valArr = userData.cart.values.toList();

                  return ListView.builder(
                      itemCount: keyArr.length,
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (context, i) {
                        return Dismissible(
                          key: Key(i.toString()),
                          onDismissed: (direction) {
                            Provider.of<FireStoreService>(context,
                                    listen: false)
                                .deleteFromTheCart(
                                    uid, userData.cart.keys.toList()[i]);
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
                              child: FutureBuilder<Product>(
                                  future: fetchProduct(keyArr[i], context),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
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
                                                              uid,
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
                                                              uid,
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
                                                            uid,
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
                                    offset: Offset(0, 5)),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          );
  }
}
