import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/cart_badge.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/models/cart.dart';
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

  // Stream<AppUser?> _getCartProductSteam(BuildContext context) {
  //   uid ??= Provider.of<User?>(context, listen: false)?.uid;
  //   return _pStream ??=
  //       Provider.of<FireStoreService>(context).getCurrentUserInfo(uid!);
  // }

  // Stream<Product?> fetchProduct(String id, BuildContext context) {
  //   return Provider.of<FireStoreService>(context).getProductFromId(id);
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    var cartModal = Provider.of<CartData>(context);
    List<Product> ps = cartModal.products;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'cart page',
          ),
          elevation: 0,
          actions: [CartBadge(cartCount: ps.length)],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: ps.length,
                  itemBuilder: (context, i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.network(
                            ps[i].image,
                            width: 100,
                            height: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ps[i].title),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "\$ ${ps[i].price * cartModal.qtyMap[ps[i].id]!}",
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await cartModal.updateQty(true, ps[i].id);
                                  },
                                  icon: const Icon(Icons.add)),
                              Text(cartModal.qtyMap[ps[i].id].toString()),
                              IconButton(
                                  onPressed: () async {
                                    await cartModal.updateQty(false, ps[i].id);
                                  },
                                  icon: const Icon(Icons.remove))
                            ],
                          )
                        ],
                      )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${cartModal.grandTotal}\$',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 30)),
                ElevatedButton(
                  child: Row(
                    children: const [
                      Text('Checkout'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.east)
                    ],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ));
  }
}
