import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/constant.dart';
import 'package:flutter101/models/order.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/src/provider.dart';
import 'package:intl/intl.dart';

const kboldText = TextStyle(fontWeight: FontWeight.w600);

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final List<String> category = OrderStatus.keys.toList();

  String _selected = 'delivered';

  TextStyle statusStyle(status) {
    switch (status) {
      case 'processing':
        return const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue);
      case 'cancelled':
        return const TextStyle(fontWeight: FontWeight.w600, color: Colors.red);
      default:
        return const TextStyle(
            fontWeight: FontWeight.w600, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: SizedBox(
                height: 35,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selected = category[index];
                              });
                            },
                            child: Container(
                              decoration: category[index] == _selected
                                  ? const BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)))
                                  : null,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  category[index],
                                  style: category[index] == _selected
                                      ? const TextStyle(
                                          fontSize: 17, color: Colors.white)
                                      : const TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Order>>(
                  stream: context
                      .read<FireStoreService>()
                      .getMyOrders(context.read<User?>()!.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Order>> orderSnap) {
                    if (orderSnap.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (orderSnap.hasError) {
                      return const Text('Failed to load data');
                    }

                    List<Order> orders = orderSnap.data!;
                    return ListView.builder(
                        itemCount: orders
                            .where((element) => element.status == _selected)
                            .length,
                        itemBuilder: (context, index) {
                          Order currentOrder = orders
                              .where((element) => element.status == _selected)
                              .toList()[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'order#$index',
                                          style: kboldText,
                                        ),
                                        Text(formatter
                                            .format(currentOrder.orderDate))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text('Item Count:'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${currentOrder.items.length}',
                                              style: kboldText,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Total Amount:'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${currentOrder.total} $kcurrency',
                                              style: kboldText,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          onPressed: () {},
                                        ),
                                        Text(
                                          OrderStatus[currentOrder.status]!,
                                          style:
                                              statusStyle(currentOrder.status),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ));
  }
}
