class Customer {
  int id;
  String name;
  String phone;

  Customer({
    this.id,
    this.name,
    this.phone,
  });

  Customer.fromMap(Map map) {
    id = map[id];
    name = map[name];
    phone = map[phone];
  }
}
