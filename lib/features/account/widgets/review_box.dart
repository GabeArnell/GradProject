import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/services/review_service.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class ReviewBox extends StatefulWidget {
  final String writer;
  final String content;
  final String subject;
  final int timestamp;
  final Function deleteCallback;
  ReviewBox({super.key, required this.writer, required this.content, required this.subject, required this.timestamp, required this.deleteCallback});

  @override
  State<ReviewBox> createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<ReviewBox> {
  ReviewService reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      color: GlobalVariables.greyBackgroundColor,
      child: Column(
        
        children: [

          Text(
            
                  '${widget.writer} says',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
          Container(
            child: Text(
                    '${widget.content}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                    maxLines: 100,
                  ),
          ),
          if (user.type == "Admin")
              IconButton(
                onPressed: () {
                  reviewService.deleteReview(context: context, writer: widget.writer, subject: widget.subject);
                  widget.deleteCallback();
                },
                
                icon: const Icon(Icons.delete_sharp),
              ),

        ],
      ),
    );
  }
}
