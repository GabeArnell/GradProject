import 'package:flutter/material.dart';
import 'dart:convert';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({
    required this.messageContent,
    required this.messageType,
  });


  Map<String, dynamic> toMap() {
    return {
      'messageContent': messageContent,
      'messageType': messageType,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageContent: map['messageContent'] ?? '',
      messageType: map['messageType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));
}
