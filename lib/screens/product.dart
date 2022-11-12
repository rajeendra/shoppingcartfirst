import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartfirst/database/db_helper.dart';
import 'package:shoppingcartfirst/database/data.dart' as data;
import 'package:shoppingcartfirst/model/item_model.dart';
import 'package:shoppingcartfirst/model/cart_model.dart';
import 'package:shoppingcartfirst/provider/cart_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppingcartfirst/screens/cart_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Product extends StatefulWidget {
  const Product({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  DBHelper dbHelper = DBHelper();
  List<bool> tapped = [];
  List<Item> products = data.products;
  bool isAddedOne = false;

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product detail'),
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
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
      body: _buildCard(),
    );

  }

  Widget _buildCard() {
    int index = widget.index;
    final cart = Provider.of<CartProvider>(context);

    List<String> carouselSliderImages = [products[index].image];
    if(products[index].images.length>0){
      carouselSliderImages = products[index].images;
    }
    String price = products[index].price.toStringAsFixed(2);
    String name = products[index].name;

    isAddedOne = false;
    if (cart.isItemAdded(products[index].productId)){
      isAddedOne = true;
    }

    void saveData() {
      if (cart.isItemAdded(products[index].productId)){
        return;
      }
      dbHelper
          .insert(
        Cart(
          id: index,
          productId: products[index].productId,
          productName: products[index].name,
          initialPrice: products[index].price,
          productPrice: products[index].price,
          quantity: ValueNotifier(1),
          unitTag: products[index].unit,
          image: products[index].image,
        ),
      )
          .then((value) {
        // Add one item first
        // Quantity adjustment option available at Cart view
        cart.addTotalPrice(products[index].price.toDouble());
        cart.addCounter();
        cart.addItemToCart(products[index].productId);

        setState(() {
          isAddedOne = true;
        });
        print('Product Added to cart');
      })
          .onError((error, stackTrace) {
        print(error.toString());
        // UNIQUE constraint failed: cart.id (code 1555)
        // if(error.toString().indexOf("1555")>0){
        //   setState(() {
        //      isAddedOne = true;
        //   });
        // }
      });
    }

    return  CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                color:  Colors.white,
                //height: 700,
                child: SizedBox(
                  //height: 210,
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10
                    ),
                    child: Column(
                      children: [
                        // Carousel Slider or Picture
                        SizedBox(
                          // Image - given width, height
                          // width: 335,
                          // height: 110,
                          // child: Image.asset(
                          //   'assets/images/kiwi.png',
                          // ),

                          // Image assets - BoxFit.fill
                          // child: Image.asset(
                          //   'assets/images/kiwi.png',
                          //   fit: BoxFit.fill,
                          // ),

                          child: _buildCarouselSlider(carouselSliderImages),

                          // Image internet - BoxFit.fill
                          // child: Image.network(
                          //   'https://via.placeholder.com/300?text=DITTO',
                          //   fit: BoxFit.fill,
                          // ),
                        ),
                        // item description
                        ListTile(
                          title: Text(
                            //'Apple iPad 5th Gen. 32GB, Wi-Fi, 9.7" Tablet, iOS 15 - Space Gray',
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                          subtitle: const Text('certified refurbished with 2 year warranty'),
                          // leading: Icon(
                          //   Icons.restaurant_menu,
                          //   color: Colors.blue[500],
                          // ),
                        ),
                        // Grading stars
                        Container(
                          //padding: const EdgeInsets.all(20),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children:[
                              Icon(
                                Icons.star_border,
                                color: Colors.blue[500],
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.blue[500],
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.blue[500],
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.blue[500],
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.blue[500],
                              ),
                            ],
                          ),
                        ),
                        // Price
                        Container(
                          //padding: const EdgeInsets.all(20),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children:[
                              Text(
                                'US\$ $price',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(width: 15,),
                              Text(
                                'US 43.64 postage',
                                style: TextStyle(
                                  //fontWeight: FontWeight.w800,
                                  //fontSize: 30,
                                ),
                              ),

                            ],
                          ),
                        ),
                        //const Divider(),
                        Container(
                          //padding: const EdgeInsets.all(20),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            'Estimated between Wed, Nov 23 and Sat, Dec 3 to 10290',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Divider(),
                        // Tel
                        ListTile(
                          title: const Text(
                            '(408) 555-1212',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.contact_phone,
                            color: Colors.blue[500],
                          ),
                        ),
                        ListTile(
                          title: const Text('costa@example.com'),
                          leading: Icon(
                            Icons.contact_mail,
                            color: Colors.blue[500],
                          ),
                        ),
                        // Buttons
                        ElevatedButton(
                          onPressed:(){
                            if(isAddedOne){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartScreen()));
                            }else {
                              saveData();
                            }
                          },
                          child: Text(isAddedOne?'Go to cart':'Add to cart'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            // primary: Colors.white,
                            // onPrimary: Colors.blue.shade900,
                            // side: BorderSide(width:3, color:Colors.blue),
                            shape: StadiumBorder(),
                            minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Watch this item'),
                          style: ElevatedButton.styleFrom(
                            //primary: Colors.blue,
                            primary: Colors.white,
                            onPrimary: Colors.blue.shade900,
                            side: BorderSide(width:3, color:Colors.blue),
                            shape: StadiumBorder(),
                            minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                        ),
                        // About this item
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'About this item',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          //padding: const EdgeInsets.all(20),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Table(
                            //border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                              //2: FixedColumnWidth(64),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Estimated',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Estimated between Wed, Nov 23 and Sat, Dec 3 to 10290',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Estimated',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Estimated between Wed, Nov 23 and Sat, Dec 3 to 10290',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Estimated',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Estimated between Wed, Nov 23 and Sat, Dec 3 to 10290',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        // item description from the seller
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'item description from the seller',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          //padding: const EdgeInsets.all(20),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            '“This Certified Refurbished product is tested and certified to look and work like new. '
                                'The refurbishing process includes functionality testing, basic cleaning, inspection, '
                                'and repackaging. The Surface ships with charger only, and will arrive in a original Microsoft Factory sealed box. '
                                'Fully refurbished by Microsoft technicians to meet the performance specifications of new Microsoft products. '
                                'Repackaged and sealed to meet Microsofts stringent final inspection requirements.”',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),
                        // Postage, Returns & Payments
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Postage, Returns & Payments',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          //padding: const EdgeInsets.all(20),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Table(
                            //border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                              //2: FixedColumnWidth(64),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Shipping',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'US 27.24 International Priority Shipping to Sri Lanka via eBay s Global Shipping Program, | See detailsfor shipping',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Located in',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Clermont, Iowa, United States',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Import charges',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Est. 47.89 Amount confirmed at checkout',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Delivery',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Estimated between Wed, Nov 23 and Sat, Dec 3 to 10290 '
                                            'Includes international tracking',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 32,
                                      width: 128,
                                      //color: Colors.red,
                                      child: Text(
                                        'Returns',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    //verticalAlignment: TableCellVerticalAlignment.top,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      //height: 32,
                                      //width: 32,
                                      //color: Colors.green,
                                      child: Text(
                                        'Seller does not accept return',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselSlider(List<String> images){
    return CarouselSlider(
      //options: CarouselOptions(height: 200.0),
      options: CarouselOptions(
        height: 200.0,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 2.0,
        initialPage: 2,
      ),

      // Basic asset image carousel demo
      //
      items: images
          .map((item) => Container(
        child: Center(
            child: Image.asset(item, fit: BoxFit.cover, width: 1000)),
      ))
          .toList(),

      // Basic internet image carousel
      //
      // items: data.netImgList
      //     .map((item) => Container(
      //           child: Center(
      //               child:
      //                   Image.network(item, fit: BoxFit.cover, width: 1000)),
      //         ))
      //     .toList(),

      // Basic text carousel
      //
      // items: [1,2,3,4,5].map((i) {
      //   return Builder(
      //     builder: (BuildContext context) {
      //       return Container(
      //           width: MediaQuery.of(context).size.width,
      //           margin: EdgeInsets.symmetric(horizontal: 5.0),
      //           decoration: BoxDecoration(
      //               color: Colors.amber
      //           ),
      //           child: Text('text $i', style: TextStyle(fontSize: 16.0),)
      //       );
      //     },
      //   );
      // }).toList(),

    );
  }
}
