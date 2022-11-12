import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcartfirst/database/db_helper.dart';
import 'package:shoppingcartfirst/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;
  Map addedProductsMAP = new Map();

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await dbHelper.getCartList();
    notifyListeners();
    return cart;
  }

  Future<void> _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    prefs.setString('added_products', jsonEncode(addedProductsMAP));
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
    String _added_products = prefs.getString('added_products') ?? '';
    if (_added_products.length>0){
      addedProductsMAP = jsonDecode(_added_products);
    }
  }

  void addItemToCart(pid){
    addedProductsMAP[pid] = pid;
    _setPrefsItems();
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }

  void addQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _quantity=cart[index].quantity!.value;
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
      _quantity = 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
      _quantity = cart[index].quantity!.value;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final pid = cart[index].productId;
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
    addedProductsMAP.remove(pid);
  }

  void checkout() async {
    int len = cart.length;
    for(int i=0; i<len; i++){
      await removeCartFirstItem();
    }
  }

  bool isItemAdded(String pid){
    bool avail = false;
    var p = addedProductsMAP[pid];
    if(p!=null){
      avail = true;
    }
    return avail;
  }

  Future<void> removeCartFirstItem() async {
    await dbHelper.deleteCartItem( cart[0].id!);
    removeItem(cart[0].id!);
    removeCounter();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }
}
