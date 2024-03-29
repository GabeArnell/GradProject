
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thrift_exchange/features/chat/models/chat_user_models.dart';
import 'package:thrift_exchange/features/chat/widgets/conversation_list.dart';
import "../services/chat_services.dart";
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  ChatServices chatservice = ChatServices();
  List<ChatUsers> chatUsers = [];

  @override
  void initState() {
    super.initState();
    fetchAllConversations();
    startUpdateLoop();
  }

  void fetchAllConversations() async {
    chatUsers =  (await chatservice.fetchConversations(context)).cast<ChatUsers>(); 
    setState(() {});
  }

  startUpdateLoop() {
    Timer.periodic(Duration(milliseconds: 10000), (timer) {
      setState(() {
        fetchAllConversations();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    // Container(
                    //   padding:
                    //       EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    //   height: 30,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color: Colors.pink[50],
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(
                    //         Icons.add,
                    //         color: Colors.pink,
                    //         size: 20,
                    //       ),
                    //       SizedBox(
                    //         width: 2,
                    //       ),
                    //       Text(
                    //         "Add New",
                    //         style: TextStyle(
                    //             fontSize: 14, fontWeight: FontWeight.bold),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: "Search...",
            //       hintStyle: TextStyle(color: Colors.grey.shade600),
            //       prefixIcon: Icon(
            //         Icons.search,
            //         color: Colors.grey.shade600,
            //         size: 20,
            //       ),
            //       filled: true,
            //       fillColor: Colors.grey.shade100,
            //       contentPadding: EdgeInsets.all(8),
            //       enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(20),
            //           borderSide: BorderSide(color: Colors.grey.shade100)),
            //     ),
            //   ),
            // ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  email: chatUsers[index].email,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
