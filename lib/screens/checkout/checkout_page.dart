import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter101/services/analytics_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter101/constant.dart';
import 'package:flutter101/models/cart.dart';
import 'package:flutter101/models/order.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';

const kboldText = TextStyle(fontWeight: FontWeight.w600);

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map<String, double> convertCartToOrderItem(BuildContext context) {
    CartData cart = Provider.of<CartData>(context, listen: false);
    List<Map<String, dynamic>> titleAmountMap = cart.products
        .map((p) => {
              'title': p.title,
              'amount': cart.qtyMap[p.id]!.toDouble() * p.price.toDouble()
            })
        .toList();

    Map<String, double> res = {};
    for (int i = 0; i < titleAmountMap.length; i++) {
      res[titleAmountMap[i]['title']] = titleAmountMap[i]['amount'] as double;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    CartData cart = Provider.of<CartData>(context);
    User? user = Provider.of<User?>(context);
    FireStoreService fireStore = Provider.of<FireStoreService>(context);
    String uid = user == null ? '' : user.uid;
    double subtotal = cart.grandTotal;
    double tax = 0.0;
    double discount = 0.0;
    double finalAmount = subtotal + tax - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Items in order',
            ),
            const Divider(thickness: 3, color: Colors.purple),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: cart.products.length,
              itemBuilder: (context, index) {
                int qty = cart.qtyMap[cart.products[index].id]!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '$qty x ${cart.products[index].title}',
                      style: kboldText,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('${qty * cart.products[index].price}$kcurrency'),
                  ],
                );
              },
            )),
            const Divider(thickness: 1, color: Colors.purple),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'subtotal',
                  style: kboldText,
                ),
                Text('$subtotal$kcurrency')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Tax',
                  style: kboldText,
                ),
                Text('$tax$kcurrency')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Discount',
                  style: kboldText,
                ),
                Text('-$discount$kcurrency')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Final Amount',
                  style: kboldText,
                ),
                Text('$finalAmount$kcurrency')
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Pay ${finalAmount.toInt()}$kcurrency',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    onPressed: () async {
                      Order ord = Order(
                          total: finalAmount,
                          status: 'processing',
                          ownerId: uid,
                          items: convertCartToOrderItem(context),
                          orderDate: DateTime.now());
                      String orderId = await fireStore.placeOrder(ord.toJson());

                      if (orderId != '') {
                        var url = Uri.parse('$kAppServerUrl/notify');
                        var response = await http.post(url,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode(
                                {'userId': uid, 'orderId': orderId}));
                        if (response.statusCode == 200) {
                          debugPrint(response.body);
                          await context.read<Analytics>().logOrders(
                              context.read<CartData>().grandTotal,
                              uid,
                              context.read<CartData>().qtyMap);
                          await context.read<CartData>().clearCart();
                        } else {
                          debugPrint(response.statusCode.toString());
                          debugPrint('A network error occurred');
                        }
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Row(
                              children: const [
                                Icon(
                                  Icons.error,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text('Not able to process your order.')
                              ],
                            ),
                            content:
                                const Text('please try again after some time.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
