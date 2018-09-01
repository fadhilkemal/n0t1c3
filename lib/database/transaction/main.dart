import 'dart:async';
import 'dart:core';

import 'package:notice/database/dbhelper.dart';
import 'package:notice/models/models.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
class TransactionRepositoryFlutter {
  const TransactionRepositoryFlutter();
//   Future<List> loadTransaction() async {
//     try {
//       return await fileStorage.loadTransaction();
//     } catch (e) {
//       return [
//         "Umum",
//         "Paket",
//         "Jantung",
//         "Alkes",
//         "Diabetes",
//         "Imunisasi",
//         "Suplemen",
//         "Persalinan",
//       ];
//     }
//   }

  Future saveTransaction(SaleOrder payload) async {
    var dbHelper = DBHelper();
    await dbHelper.dbSaveTransaction(payload);
    // final fetchResult2 = await dbHelper.getSaleOrders();
    // print("$fetchResult2");
    // return Future.wait<dynamic>([
    //     dbHgetProducts

    //   fileStorage.saveTransaction(transaction),
    // ]);
  }
}
