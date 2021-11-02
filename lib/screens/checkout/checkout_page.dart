import 'package:firebase_auth/firebase_auth.dart';
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
                      await fireStore.placeOrder(ord.toJson());
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Row(
                            children: const [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Order placed Successfully')
                            ],
                          ),
                          content: const Text(
                              'You can check and track your order in my order tab'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await context.read<CartData>().clearCart();
                                Navigator.pushReplacementNamed(
                                    context, 'orders_page');
                              },
                              child: const Text('My Orders'),
                            ),
                          ],
                        ),
                      );
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
