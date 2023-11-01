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
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.red,
      //   unselectedItemColor: Colors.grey.shade600,
      //   selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      //   unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.message),
      //       label: "Chats",
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.group_work),
      //     //   label: "Channels",
      //     // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_box),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }
}
