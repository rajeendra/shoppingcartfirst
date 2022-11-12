import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartfirst/database/db_helper.dart';
import 'package:shoppingcartfirst/database/data.dart' as data;
import 'package:shoppingcartfirst/model/cart_model.dart';
import 'package:shoppingcartfirst/provider/cart_provider.dart';
import 'package:shoppingcartfirst/paymentgateway/api_paypal_braintree.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Shopping Cart'),
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
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.cart.isEmpty) {
                  return const Center(
                      child: Text(
                    'Your Cart is Empty',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
                        String cat = data.getCatByPID(provider.cart[index].productId!);
                        return Card(
                          //color: Colors.blueGrey.shade200,
                          //color: Colors.tealAccent,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  height: 80,
                                  width: 80,
                                  image:
                                      AssetImage(provider.cart[index].image!),
                                ),
                                _buildByCat(cat,index,provider),
                                ValueListenableBuilder<int>(
                                    valueListenable:
                                        provider.cart[index].quantity!,
                                    builder: (context, val, child) {
                                      return PlusMinusButtons(
                                        addQuantity: (){
                                          _addQuantity(cart, provider, index);
                                        },
                                        deleteQuantity: () {
                                          _deleteQuantity(cart, provider, index);
                                        },
                                        text: val.toString(),
                                      );
                                    }),
                                // IconButton(
                                //     onPressed: () {
                                //       _deleteCartItem(provider, index);
                                //     },
                                //     icon: Icon(
                                //       Icons.delete,
                                //       color: Colors.red.shade800,
                                //     )),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          // Display total
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              final ValueNotifier<int?> totalPrice = ValueNotifier(null);
              for (var element in value.cart) {
                totalPrice.value =
                    (element.productPrice! * element.quantity!.value) +
                        (totalPrice.value ?? 0);
              }
              return Column(
                children: [
                  ValueListenableBuilder<int?>(
                      valueListenable: totalPrice,
                      builder: (context, val, child) {
                        return ReusableWidget(
                            title: 'Sub-Total',
                            value: r'$' + (val?.toStringAsFixed(2) ?? '0'));
                      }),
                ],
              );
            },
          )
        ],
      ),
      // Proceed to pay
      bottomNavigationBar: InkWell(
        onTap: () async {
          if(cart.counter > 0){
            final result = await APIPayPalBraintree().doPayment(cart.totalPrice);
            if (result != null) {
              cart.checkout();
              APIPayPalBraintree().showNonce(result, context);
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empty cart: Can not proceed to payment'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Container(
          color: Colors.yellow.shade600,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Proceed to Pay',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _addQuantity(cart, provider, index) {
    //final cart = Provider.of<CartProvider>(context);
    cart.addQuantity(provider.cart[index].id!);
    dbHelper!
        .updateQuantity(Cart(
            id: index,
            productId: provider.cart[index].productId,
            productName: provider.cart[index].productName,
            initialPrice: provider.cart[index].initialPrice,
            productPrice: provider.cart[index].productPrice,
            quantity: ValueNotifier(provider.cart[index].quantity!.value),
            unitTag: provider.cart[index].unitTag,
            image: provider.cart[index].image))
        .then((value) {
          setState(() {
            cart.addTotalPrice(
                double.parse(provider.cart[index].productPrice.toString()));
          });
        });
  }

  _deleteQuantity(cart, provider, index) {
    if(provider.cart[index].quantity!.value==1){
      _deleteCartItem(provider, index);
      return;
    }
    cart.deleteQuantity(provider.cart[index].id!);
    dbHelper!
        .updateQuantity(Cart(
        id: index,
        productId: provider.cart[index].productId,
        productName: provider.cart[index].productName,
        initialPrice: provider.cart[index].initialPrice,
        productPrice: provider.cart[index].productPrice,
        quantity: ValueNotifier(provider.cart[index].quantity!.value),
        unitTag: provider.cart[index].unitTag,
        image: provider.cart[index].image));

    cart.removeTotalPrice(
        double.parse(provider.cart[index].productPrice.toString()));
  }

  _deleteCartItem(providerx, index) {
    dbHelper!.deleteCartItem(providerx.cart[index].id!);
    providerx.removeItem(providerx.cart[index].id!);
    providerx.removeCounter();
  }

  Widget _buildByCat(String cat, int index, provider){
    if(cat == 'electronic'){
      return _buildElectronicCard(index, provider);
    }
    return _buildFruitCard(index, provider);
  }

  Widget _buildFruitCard(index, provider){
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
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
                      '${provider.cart[index].productName!}\n',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold)),
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
                      '${provider.cart[index].unitTag!}\n',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold)),
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
                      '${provider.cart[index].productPrice!}\n',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold)),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildElectronicCard(index, provider){
    return Container(
      //width: 130,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5.0,
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
                    '${provider.cart[index].productName!}\n',
                    style: TextStyle(
                      //fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  //height: 5.0,
                  child: Text(
                    'US\$  ${provider.cart[index].productPrice.toStringAsFixed(2)!}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
