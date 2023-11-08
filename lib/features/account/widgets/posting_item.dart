import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/stars.dart';
import 'package:thrift_exchange/models/product.dart';

class PostingItem extends StatefulWidget {
  const PostingItem({super.key, required this.product});
  final Product product;
  @override
  State<PostingItem> createState() => _PostingItemState();
}

class _PostingItemState extends State<PostingItem> {
  @override
  Widget build(BuildContext context) {
    var product;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
