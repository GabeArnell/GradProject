import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/features/chat/models/chat_message_model.dart';
import 'package:thrift_exchange/features/chat/models/chat_user_models.dart';
import 'package:thrift_exchange/models/message.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:thrift_exchange/providers/user_provider.dart';

class ChatServices {
  void sendMessage({
    required BuildContext context,
    required String recipient,
    required String content,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/send-message'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "recipient": recipient,
          "content": content.trim(),
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Sent message!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<ChatUsers>> fetchConversations(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ChatUsers> chatUserList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$SERVER_URI/api/get-conversation-headers'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            chatUserList.add(
              ChatUsers.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return chatUserList;
  }


  Future<List<ChatMessage>> getConversation(BuildContext context, String email) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ChatMessage> chatMessageList = [];
    try {
      http.Response res =
        await http.post(Uri.parse('$SERVER_URI/api/get-conversation-history'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
        body: jsonEncode({
          "email": email
        }),
      
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            chatMessageList.add(
              ChatMessage.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return chatMessageList;
  }


}
