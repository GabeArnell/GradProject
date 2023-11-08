import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/features/cart/services/cart_services.dart';
import 'package:thrift_exchange/features/home/services/product_services.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  Product product;
  CartProduct({super.key, required this.index, required this.product});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductServices productServices = ProductServices();
  final CartServices cartServices = CartServices();

  void increaseQuantity() {
    widget.product.quantity = widget.product.quantity + 1;
    productServices.addToCart(context: context, product: widget.product);
  }

  void decreaseQuantity() {
    if (widget.product.quantity > 0){
      widget.product.quantity = widget.product.quantity - 1;
      cartServices.removeFromCart(context: context, product: widget.product);
    }
  }

  @override
  Widget build(BuildContext context)  {

    final quantity = widget.product.quantity;
    print("Cart Product");
    print(widget.product.quantity);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Image.network(
                widget.product.images[0],
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
                      widget.product.name,
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
                      '\$${widget.product.price}',
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
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 12,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decreaseQuantity(),
                      child: Container(
                        width: 35,
                        height: 33,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 17,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: 35,
                        height: 33,
                        alignment: Alignment.center,
                        child: Text(
                          quantity.toString().split(".")[0],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(),
                      child: Container(
                        width: 35,
                        height: 33,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
