class Product {
  int id;
  String name;
  String description;
  String category;
  double price;

  Product({
    this.name,
    this.description,
    this.category,
    this.price,
    this.id,
  });

  Product.fromMap(Map map) {
    id = map[id];
    name = map[name];
    description = map[description];
    category = map[category];
    price = map[price];
  }
}
