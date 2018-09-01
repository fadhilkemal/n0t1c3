// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

class TodoEntity {
  final bool complete;
  final String id;
  final String note;
  final String task;
  final int quantity;
  final double price;
  final String category;

  TodoEntity(this.task, this.id, this.note, this.complete, this.quantity,
      this.price, this.category);

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoEntity &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          quantity == other.quantity &&
          price == other.price &&
          category == other.category &&
          id == other.id;

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
      "id": id,
      "quantity": quantity,
      "price": price,
      "category": category,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{task: $task, quantity: $quantity, price: $price}';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json["task"] as String,
      json["id"] as String,
      json["note"] as String,
      json["complete"] as bool,
      json["quantity"] as int,
      json["price"] as double,
      json["category"] as String,
    );
  }
}
