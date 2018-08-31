// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:notice/fas_copy/uuid.dart';
import 'package:meta/meta.dart';
import 'package:notice/tr_copy/todos_repository.dart';

@immutable
class Todo {
  final bool complete;
  final String id;
  final String note;
  final String task;
  final int quantity;
  final double price;
  final String category;

  Todo(
    this.task, {
    this.complete = false,
    String note = '',
    String id,
    int quantity,
    double price,
    String category,
  })  : this.note = note ?? '',
        this.quantity = quantity ?? 0,
        this.price = price ?? 0.0,
        this.category = category ?? 'Umum',
        this.id = id ?? Uuid().generateV4();

  Todo copyWith({
    bool complete,
    String id,
    String note,
    String task,
    int quantity,
    double price,
    String category,
  }) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          quantity == other.quantity &&
          price == other.price &&
          category == other.category &&
          id == other.id;

  @override
  String toString() {
    return 'Todo{name: $task, categ: $category, price: $price, id: $id}';
  }

  TodoEntity toEntity() {
    return TodoEntity(
      task,
      id,
      note,
      complete,
      quantity,
      price,
      category,
    );
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      quantity: entity.quantity,
      price: entity.price,
      category: entity.category,
      id: entity.id ?? Uuid().generateV4(),
    );
  }
}
