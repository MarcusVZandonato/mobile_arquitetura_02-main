class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final bool isFavorited;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    this.isFavorited = false,
  });

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    String? description,
    bool? isFavorited,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
