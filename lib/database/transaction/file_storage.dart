// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Loads and saves a List of Todos using a text file stored on the device.
///
/// Note: This class has no direct dependencies on any Flutter dependencies.
/// Instead, the `getDirectory` method should be injected. This allows for
/// testing.
class CategFileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const CategFileStorage(
    this.tag,
    this.getDirectory,
  );

  Future<List> loadCateg() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);

    final categ = (json['categ'])
        // .map<TodoEntity>((todo) => TodoEntity.fromJson(todo))
        .toList();

    return categ;
    // try {
    //   return await loadCategFromJson();
    // } catch (e) {
    //   return ["todos"];
    // }
  }

  Future<List> loadCategFromJson() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);

    final categ = (json['categ'])
        // .map<TodoEntity>((todo) => TodoEntity.fromJson(todo))
        .toList();

    return categ;
  }

  Future<File> saveCateg(List categ) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert({
      'categ': categ,
    }));
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/ArchSampleStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
