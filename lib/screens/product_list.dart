import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartfirst/model/item_model.dart';
import 'package:shoppingcartfirst/provider/cart_provider.dart';
import 'package:shoppingcartfirst/database/db_helper.dart';
import 'package:shoppingcartfirst/database/data.dart' as data;
import 'package:shoppingcartfirst/screens/cart_screen.dart';
import 'package:shoppingcartfirst/screens/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBHelper dbHelper = DBHelper();
  List<Item> products = data.products;
  bool badgeValueFetched = false;

  @override
  void initState() {
    super.initState();
    badgeValueFetched = false;
  }

  //List<bool> clicked = List.generate(10, (index) => false, growable: true);
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterBuild(context));
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product list'),
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  //value.getCounter().toString(),
                  value.counter.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            String cat = products[index].category;
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Product(index: index,)));
                },
                child: Card(
              //color: Colors.blueGrey.shade200,
              //color: cat=='fruits'?Colors.tealAccent :Colors.white,
              color: cat=='fruits'?Colors.white :Colors.white,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: _buildByCat(cat, index),
                ),
              ),
            ),
            );
          }),
    );
  }

  void afterBuild(ctx) async {
    // executes after build is done
    if(!badgeValueFetched){
      String result = await context.read<CartProvider>().initBadge();
      badgeValueFetched = true;
    }
  }

  List<Widget> _buildByCat(String cat, int index){
    if(cat == 'electronic'){
      return _buildElectronicCard(index);
    }
    return _buildFruitCard(index);
  }

  List<Widget> _buildFruitCard(int index){
    List<Widget> widgets = [
      Image(
        height: 100,
        width: 100,
        image: AssetImage(products[index].image.toString()),
      ),
      SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5.0,
            ),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                  //text: 'Name: ',
                  text: '',
                  style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 16.0),
                  children: [
                    TextSpan(
                        text:
                        '${products[index].name.toString()}\n',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)),
                  ]),
            ),
            RichText(
              maxLines: 1,
              text: TextSpan(
                  text: 'Unit: ',
                  style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 16.0),
                  children: [
                    TextSpan(
                        text:
                        '${products[index].unit.toString()}\n',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
            RichText(
              maxLines: 1,
              text: TextSpan(
                  text: 'Price: ' r"$",
                  style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 16.0),
                  children: [
                    TextSpan(
                        text:
                        '${products[index].price.toString()}\n',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
          ],
        ),
      )
    ];
    return widgets;
  }

  List<Widget> _buildElectronicCard(int index){
    List<Widget> widgets = [
      Image(
        height: 150,
        width: 150,
        image: AssetImage(products[index].image.toString()),
      ),
      SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
              //height: 5.0,
              child: Text(
                '${products[index].name.toString()}\n',
                style: TextStyle(
                  //fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              //height: 5.0,
              child: Text(
                'US\$  ${products[index].price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return widgets;
  }

}
