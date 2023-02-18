import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './pages/home_page.dart';
import './pages/add_product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Products>(
      create: (context) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          HomePage.routeName: (ctx) => const HomePage(),
          AddProductPage.routeName: (ctx) => const AddProductPage(),
        },
      ),
    );
  }
}