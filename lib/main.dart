import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartfirst/provider/cart_provider.dart';
import 'package:shoppingcartfirst/screens/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const ProductList(),
        );
      }),
    );
  }
}
