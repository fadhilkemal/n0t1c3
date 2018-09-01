import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Product(id INTEGER PRIMARY KEY, name TEXT, description TEXT, category TEXT, price FLOAT )");
    await db.execute(
        "CREATE TABLE sale_order(id INTEGER PRIMARY KEY, name TEXT, customer TEXT, order_date TEXT, detail TEXT, pay_method TEXT, price_discount FLOAT, price_total FLOAT )");
  }

  void saveEmployee(Product product) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Product(name, description, category, price ) VALUES(' +
              '\'' +
              product.name +
              '\'' +
              ',' +
              '\'' +
              product.description +
              '\'' +
              ',' +
              '\'' +
              product.category +
              '\'' +
              ',' +
              '\'' +
              "${product.price}" +
              '\'' +
              ')');
    });
  }

  void dbSaveTransaction(SaleOrder order) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO sale_order(name, customer, order_date, detail, pay_method, price_discount, price_total ) VALUES(' +
              '\'' +
              '${order.name}' +
              '\'' +
              ',' +
              '\'' +
              '${order.customer}' +
              '\'' +
              ',' +
              '\'' +
              '${order.order_date}' +
              '\'' +
              ',' +
              '\'' +
              '${order.detail}' +
              '\'' +
              ',' +
              '\'' +
              '${order.pay_method}' +
              '\'' +
              ',' +
              '\'' +
              '2000' +
              '\'' +
              ',' +
              '\'' +
              '${order.price_total}' +
              '\'' +
              ')');
    });
  }

  Future<List<Product>> getProducts() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Product');

    List<Product> product = new List();
    for (int i = 0; i < list.length; i++) {
      product.add(
        new Product(
          id: list[i]["id"],
          name: list[i]["name"],
          description: list[i]["description"],
          category: list[i]["category"],
          price: list[i]["price"],
        ),
      );
    }
    return product;
  }

  Future<List<Category>> getCategories() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT DISTINCT category FROM Product ORDER BY category;');
    List<Category> category = new List();
    for (int i = 0; i < list.length; i++) {
      category.add(
        new Category(
          name: list[i]["category"],
        ),
      );
    }
    return category;
  }

  Future<List<Category>> getTransactions() async {
    print("GET TRANSACTION");
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM sale_order;');
    List<Category> category = new List();
    for (int i = 0; i < list.length; i++) {
      Map transactionDetail = JsonDecoder().convert(list[i]["detail"]);
      print(transactionDetail["order_line"]);
      print(list[i]['name']);
      //   print(
      //     // list[i]["detail"][0],
      //     JsonDecoder().convert(list[i]["detail"]),
      //   );
      //   category.add(
      //     new Category(
      //       name: list[i]["category"],
      //     ),
      //   );
    }
    // return category;
  }
}