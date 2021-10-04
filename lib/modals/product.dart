import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String image, title, description;
  final int price, id, color;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.color,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
        id: doc.get('id'),
        image: doc.get('image'),
        title: doc.get('title'),
        price: doc.get('price'),
        description: doc.get('description'),
        color: doc.get('color'));
  }
}

List<Product> products = [
  Product(
      id: 1,
      title: "Office Code",
      price: 234,
      description: dummyText,
      image: "assets/images/bag_1.png",
      color: 4282221230),
  Product(
    id: 2,
    title: "Belt Bag",
    price: 234,
    description: dummyText,
    image: "assets/images/bag_2.png",
    color: 4282221230,
  ),
  Product(
      id: 3,
      title: "Hang Top",
      price: 234,
      description: dummyText,
      image: "assets/images/bag_3.png",
      color: 4282221230),
  Product(
      id: 4,
      title: "Old Fashion",
      price: 234,
      description: dummyText,
      image: "assets/images/bag_4.png",
      color: 4282221230),
  Product(
      id: 5,
      title: "Office Code",
      price: 234,
      description: dummyText,
      image: "assets/images/bag_5.png",
      color: 4282221230),
  Product(
      id: 6,
      title: "Office Code",
      price: 234,
      description: dummyText,
      image: "assets/images/bag_6.png",
      color: 4282221230),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
