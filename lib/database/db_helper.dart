import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:shoppingcartfirst/model/cart_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    //return null;
    return _database!;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    /*
      'CREATE TABLE
        cart(
            id INTEGER PRIMARY KEY,
            productId VARCHAR UNIQUE,
            productName TEXT,
            initialPrice INTEGER,
            productPrice INTEGER,
            quantity INTEGER,
            unitTag TEXT,
            image TEXT)'
        );

        late final int? id;
        final String? productId;
        final String? productName;
        final int? initialPrice;
        final int? productPrice;
        final ValueNotifier<int>? quantity;
        final String? unitTag;
        final String? image;
    * */
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    List<Cart> cartItems = [];
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    cartItems = queryResult.map((result) => Cart.fromMap(result)).toList();
    return cartItems;
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    return await dbClient!.update('cart', cart.quantityMap(),
        where: "productId = ?", whereArgs: [cart.productId]);
  }

  Future<List<Cart>> getCartId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
        await dbClient!.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<List<Cart>> getCartProductId(String pid) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
    await dbClient!.query('cart', where: 'productId = ?', whereArgs: [pid]);
    return queryIdResult.map((e) => Cart.fromMap(e)).toList();
  }
}
