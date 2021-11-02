import 'package:flutter/material.dart';
import '../../../constant.dart';

class CategoryList extends StatefulWidget {
  final Function changeCategory;
  const CategoryList({Key? key, required this.changeCategory})
      : super(key: key);
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<String> category = [
    'bags',
    'phone',
    'jewellery',
    'shoes',
    'clothes'
  ];

  int _selected = 0;

  Function changeCategory = () {};
  @override
  void initState() {
    super.initState();
    changeCategory = widget.changeCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: category.length,
          itemBuilder: buildCategory,
        ),
      ),
    );
  }

  Widget buildCategory(context, index) => GestureDetector(
        onTap: () {
          setState(() {
            _selected = index;
            changeCategory(category[index]);
          });
        },
        child: Container(
          decoration: index == _selected
              ? const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(100)))
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              category[index],
              style: index == _selected
                  ? const TextStyle(fontSize: 17, color: Colors.white)
                  : const TextStyle(fontSize: 17),
            ),
          ),
        ),
      );
}
