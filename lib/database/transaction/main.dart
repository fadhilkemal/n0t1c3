import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
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
    final fetchResult = await dbHelper.dbSaveTransaction(payload);
    final fetchResult2 = await dbHelper.getTransactions();
    print("$payload");
    // print("$fetchResult");
    print("$fetchResult2");
    print("saveTransaction saveTransaction 123");
    // return Future.wait<dynamic>([
    //     dbHgetProducts

    //   fileStorage.saveTransaction(transaction),
    // ]);
  }
}
