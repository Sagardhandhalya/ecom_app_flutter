import 'package:flutter/material.dart';
import './../constant.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<String> category = [
    'Hand Bags',
    'Mobile phone',
    'Jwelory',
    'Shoews',
    'clothes'
  ];

  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: buildCategory,
      ),
    );
  }

  Widget buildCategory(context, index) => GestureDetector(
        onTap: () {
          setState(() {
            _selected = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(
              top: kDefaultPaddin, right: kDefaultPaddin, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category[index],
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 5,
                width: 40,
                color: index == _selected ? Colors.black : Colors.transparent,
              )
            ],
          ),
        ),
      );
}
