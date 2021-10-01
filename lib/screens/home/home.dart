import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/custom_drawer.dart';
import '../../modals/product.dart';
import '../home/components/category_list.dart';
import '../product_details/details_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  MaterialColor col(int x) {
    return x % 2 == 0 ? Colors.amber : Colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Products',
          ),
          elevation: 0,
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
        body: StreamBuilder<QuerySnapshot>(
            stream: _productStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CategoryList(),
                      Expanded(
                          child: GridView.builder(
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5),
                              itemBuilder: (context, index) =>
                                  buildProductCard(context, index, snapshot)))
                    ],
                  ));
            }));
  }

  Widget buildProductCard(
      BuildContext context, int index, AsyncSnapshot<QuerySnapshot> snapshot) {
    var product = snapshot.data!.docs[index];
    // Product product = products[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(product: Product.fromDocument(product))));
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 180,
            child: Hero(
              child: Image.network(product["image"]),
              tag: products[index].id,
            ),
            decoration: BoxDecoration(
                color: Color(product["color"]),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            product["title"],
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text("\$ ${product["price"]}",
              style: Theme.of(context).textTheme.bodyText1)
        ],
      ),
    );
  }
}
