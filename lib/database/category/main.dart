import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'file_storage.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
class CategRepositoryFlutter {
  final CategFileStorage fileStorage;

  const CategRepositoryFlutter({
    @required this.fileStorage,
  });

  Future<List> loadCateg() async {
    try {
      return await fileStorage.loadCateg();
    } catch (e) {
      return [
        "Umum",
        "Paket",
        "Jantung",
        "Alkes",
        "Diabetes",
        "Imunisasi",
        "Suplemen",
        "Persalinan",
      ];
    }
  }

  Future saveCateg(List categ) {
    return Future.wait<dynamic>([
      fileStorage.saveCateg(categ),
    ]);
  }
}
