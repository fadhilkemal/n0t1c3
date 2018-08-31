class Category {
  String name;

  Category({
    this.name,
  });

  Category.fromMap(Map map) {
    name = map[name];
  }

  static Category fromEntity(entity) {
    return Category(
      name: entity,
    );
  }

  @override
  String toString() {
    return 'Category{name: $name}';
  }
}
