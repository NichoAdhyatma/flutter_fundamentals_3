import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductItem extends StatefulWidget {
  const ProductItem(Key key, this.prodId, this.title, this.date)
      : super(key: key);

  final String prodId, title;

  final DateTime date;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late Color colorBg;
  @override
  void initState() {
    super.initState();
    List<Color> myColor = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.black,
      Colors.grey,
      Colors.orange,
      Colors.amber,
      Colors.cyan,
    ];

    colorBg = myColor[Random().nextInt(myColor.length)];
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorBg,
      ),
      title: Text(widget.title),
      subtitle: Text(DateFormat.yMMMEd().format(widget.date)),
      trailing: IconButton(
        onPressed: () => products.deleteProduct(widget.prodId),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}
