class Item {
  final String productId;
  final String category;
  final String name;
  final String unit;
  final int price;
  final String image;
  final List<String> images;

  Item({required this.productId, required this.category, required this.name, required this.unit, required this.price, required this.image, required this.images});

  Map toJson() {
    return {
      'productId': productId,
      'category': category,
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }
}
