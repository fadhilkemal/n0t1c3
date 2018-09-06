class Product {
  int id;
  String name;
  String description;
  String category;
  double price;

  Product({
    this.id,
    this.name,
    this.description,
    this.category,
    this.price,
  });

  Product.fromMap(Map map) {
    id = map[id];
    name = map[name];
    description = map[description];
    category = map[category];
    price = map[price];
  }
}
