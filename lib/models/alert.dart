import 'dart:convert';

class Alert {
  final String id;
  final String email;
  final String zipcode;
  final String name;
  final String category;

  Alert({
    required this.id, required this.email,required this.zipcode,required this.name,required this.category, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'zipcode': zipcode,
      'name': name,
      'category': category,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['_id'] ?? '',
      email: map['email'] ?? '',
      category: map['category'] ?? '',
      zipcode: map['zipcode'] ?? "0",
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Alert.fromJson(String source) => Alert.fromMap(json.decode(source));
}
