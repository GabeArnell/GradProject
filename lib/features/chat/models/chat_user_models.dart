import 'package:flutter/material.dart';
import 'dart:convert';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;
  String email;
  ChatUsers(
      {required this.name,
      required this.messageText,
      required this.imageURL,
      required this.time,
      required this.email
      });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'messageText': messageText,
      'imageURL': imageURL,
      'email': email,
      'time': time,
    };
  }

  factory ChatUsers.fromMap(Map<String, dynamic> map) {
    return ChatUsers(
      name: map['name'] ?? '',
      messageText: map['messageText'] ?? '',
      imageURL: map['imageURL'] ?? '',
      email: map['email'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUsers.fromJson(String source) =>
      ChatUsers.fromMap(json.decode(source));
}
