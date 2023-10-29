import 'dart:convert';

class Message {
  final String id;
  final String sender;
  final String recipient;
  final String content;
  final int timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'recipient': recipient,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] ?? '',
      sender: map['sender'] ?? '',
      recipient: map['recipient'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));
}
