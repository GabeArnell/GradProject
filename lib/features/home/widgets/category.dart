import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String image;
  final String category;
  const CategoryWidget(
      {super.key, required this.image, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 39,
            backgroundImage: NetworkImage(image),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              text: category,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
