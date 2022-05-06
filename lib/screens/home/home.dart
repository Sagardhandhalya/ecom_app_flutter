import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/cart_badge.dart';
import 'package:flutter101/components/custom_drawer.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/constant.dart';
import 'package:flutter101/models/cart.dart';
import 'package:flutter101/screens/product_details/product_detail.dart';
import 'package:flutter101/services/analytics_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../home/components/category_list.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:badges/badges.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _category = 'bags';

  MaterialColor col(int x) {
    return x % 2 == 0 ? Colors.amber : Colors.yellow;
  }

  void changeCategory(String category) {
    setState(() {
      _category = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    int cartCount = Provider.of<CartData>(context).products.length;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Products',
          ),
          elevation: 0,
          actions: [CartBadge(cartCount: cartCount)],
        ),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryList(changeCategory: changeCategory),
              StreamBuilder<List<Product>>(
                  stream: Provider.of<FireStoreService>(context)
                      .getProductsStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!
                        .where((p) => p.category == _category)
                        .isEmpty) {
                      return Center(
                          child: Text('No Product in $_category category'));
                    }
                    return Expanded(
                        child: GridView.builder(
                            itemCount: snapshot.data!
                                .where((p) => p.category == _category)
                                .length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.7,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                            itemBuilder: (context, index) => buildProductCard(
                                context,
                                index,
                                snapshot.data!
                                    .where((p) => p.category == _category)
                                    .toList())));
                  }),
            ],
          ),
        ));
  }

  Widget buildProductCard(
      BuildContext context, int index, List<Product> snapshot) {
    var product = snapshot[index];

    return GestureDetector(
      onTap: () async {
        await context
            .read<Analytics>()
            .logViewProduct(product.id, product.title, product.category);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      product: product,
                      productUid: product.id.toString(),
                    ),
                settings: RouteSettings(name: "${product.title} page")));
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 180,
            child: Hero(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: product.image,
              ),
              tag: product.id,
            ),
            decoration: BoxDecoration(
                color: Color(product.color),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          Text(
            product.title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text("${product.price}$kcurrency",
              style: Theme.of(context).textTheme.bodyText1)
        ],
      ),
    );
  }
}
