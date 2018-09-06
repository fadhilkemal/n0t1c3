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
        "CREATE TABLE customer(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)");
    await db.execute(
        "CREATE TABLE sale_order(id INTEGER PRIMARY KEY, name TEXT, customer TEXT, order_datetime TEXT, order_date TEXT, detail TEXT, pay_method TEXT, price_discount FLOAT, price_total FLOAT )");
  }

  void saveProduct(Product product) async {
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

  Future<int> saveCustomer(Customer customer) async {
    var dbClient = await db;
    int customerId = await dbClient.transaction(
      (txn) async {
        return await txn.rawInsert(
            'INSERT INTO customer(name, phone ) VALUES(' +
                '\'' +
                customer.name +
                '\'' +
                ',' +
                '\'' +
                customer.phone +
                '\'' +
                ')');
      },
    );
    return customerId;
  }

  void dbSaveTransaction(SaleOrder order) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO sale_order(name, customer, order_datetime, order_date, detail, pay_method, price_discount, price_total ) VALUES(' +
              '\'' +
              '${order.name}' +
              '\'' +
              ',' +
              '\'' +
              '${order.customer}' +
              '\'' +
              ',' +
              '\'' +
              '${order.order_datetime}' + //   '2018-09-03 12:46:45' +
              '\'' +
              ',' +
              '\'' +
              '${order.order_date}' + //   '2018-09-03
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
              '${order.price_discount}' +
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

  Future<List<Customer>> getCustomer() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM customer');

    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      customer.add(
        new Customer(
          id: list[i]["id"],
          name: list[i]["name"],
          phone: list[i]["phone"],
        ),
      );
    }
    return customer;
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

  Future<Map> getSaleOrders() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM sale_order ORDER BY order_datetime DESC ;');
    List queryResult = await dbClient.rawQuery(
        'SELECT order_date, SUM(price_total) as price_total FROM sale_order GROUP BY order_date ORDER BY order_date DESC;');
    List<SaleOrder> transactions = new List();

    for (int i = 0; i < list.length; i++) {
      var transaction = list[i];
      Map transactionDetail = JsonDecoder().convert(transaction["detail"]);
      transactionDetail;
      //   print(transactionDetail["order_line"]);
      //   print(
      //     // transaction["detail"][0],
      //     JsonDecoder().convert(transaction["detail"]),
      //   );
      transactions.add(
        SaleOrder(
          id: transaction['id'],
          name: transaction['name'],
          customer: transaction['customer'],
          order_datetime: transaction['order_datetime'],
          order_date: transaction['order_date'],
          pay_method: transaction['pay_method'],
          price_discount: transaction['price_discount'],
          price_total: transaction['price_total'],
        ),
      );
    }

    return {
      'header': queryResult,
      'order': transactions,
    };
  }

  Future<Map> getSaleOrderDetail(int orderId) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM sale_order WHERE id=$orderId');
    Map productDetail = {
      'id': list[0]["id"],
      'name': list[0]["name"],
      'customer': list[0]["customer"],
      'order_datetime': list[0]["order_datetime"],
      'order_date': list[0]["order_date"],
      'detail': list[0]["detail"],
      'pay_method': list[0]["pay_method"],
      'price_discount': list[0]["price_discount"],
      'price_total': list[0]["price_total"],
    };
    return productDetail;
  }
}
