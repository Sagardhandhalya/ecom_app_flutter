import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String text;
  final int seconds;
  final String type;

  const CustomSnackBar({
    Key? key,
    required this.seconds,
    required this.text,
    required this.type,
  }) : super(key: key);

  IconData _getIcon() {
    switch (type) {
      case 'success':
        return Icons.done;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color _getColor() {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  SnackBar snackBar() {
    return SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _getIcon(),
              color: Colors.white,
            ),
          ),
          Expanded(
              child: Text(
            text,
            style: const TextStyle(fontSize: 17),
          )),
        ],
      ),
      duration: Duration(seconds: seconds),
      backgroundColor: _getColor(),
      behavior: SnackBarBehavior.floating,
    );
  }

  void show(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar());
  }

  @override
  Widget build(BuildContext context) {
    return snackBar();
  }
}
