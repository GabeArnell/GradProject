import 'dart:convert';

class User {
  final String id;
  String name;
  final String password;
  final String email;
  String address;
  final String type;
  String image;
  final String token;
  final List<dynamic> cart;
  List<dynamic> usedPromotions;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.address,
    required this.type,
    required this.image,
    required this.token,
    required this.cart,
    required this.usedPromotions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'address': address,
      'type': type,
      'image': image,
      'token': token,
      'cart': cart,
      'usedPromotions': usedPromotions,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      image: map['image'] ??
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png',
      token: map['token'] ?? '',
      usedPromotions: map['usedPromotions'] ?? [],
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? image,
    String? token,
    List<dynamic>? usedPromotions,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
      usedPromotions: usedPromotions ?? this.usedPromotions,
      image: image ?? this.image,
    );
  }
}
