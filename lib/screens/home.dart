import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/custom_drawer.dart';
import './../constant.dart';
import './../modals/product.dart';
import './../components/category_list.dart';
import 'details_page.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  MaterialColor col(int x) {
    return x % 2 == 0 ? Colors.amber : Colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Products',
            style: TextStyle(color: Colors.black54),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black54),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
              tooltip: 'Go to the next page',
            )
          ],
        ),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CategoryList(),
              Expanded(
                  child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.7,
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                      itemBuilder: buildProjectCard))
            ],
          ),
        ));
  }

  Widget buildProjectCard(context, index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsPage(product: products[index])));
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 180,
            child: Hero(
              child: Image.asset(products[index].image),
              tag: products[index].id,
            ),
            decoration: BoxDecoration(
                color: products[index].color,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            products[index].title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text("\$ ${products[index].price}",
              style: Theme.of(context).textTheme.bodyText1)
        ],
      ),
    );
  }
}
