import 'dart:convert';

class Product {
  final String name;
  final String description;
  double quantity;
  final List<String> images;
  final String category;
  final double price;
  final String zipcode;
  final String email;
  final String? id;
  final int views;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.zipcode,
    required this.email,
    required this.views,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'zipcode': zipcode,
      'email': email,
      'views': views,
      'id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      zipcode: map['zipcode'] ?? '',
      email: map['email'] ?? '',
      views: map['views'] ?? 0,
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
