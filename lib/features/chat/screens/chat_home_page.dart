import 'package:flutter/material.dart';
import 'package:thrift_exchange/features/chat/screens/chat_page.dart';

class ChatHomePage extends StatefulWidget {
  static const String routeName = '/chat-page';
  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
    );
  }
}
