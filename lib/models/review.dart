import 'dart:convert';

class Review {
  final String id;
  final String writer;
  final String subject;
  final String content;
  final int timestamp;

  Review({
    required this.id,
    required this.writer,
    required this.subject,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'writer': writer,
      'subject': subject,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['_id'] ?? '',
      writer: map['writer'] ?? '',
      subject: map['subject'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));
}
