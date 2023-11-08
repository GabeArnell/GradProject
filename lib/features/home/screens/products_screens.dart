import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/common/widgets/stars.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/home/screens/add_product_Screen.dart';
import 'package:thrift_exchange/features/home/screens/home_screens.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import 'package:thrift_exchange/features/home/services/home_services.dart';
import 'package:thrift_exchange/features/home/services/product_services.dart';
import 'package:thrift_exchange/models/product.dart';

import '../../chat/services/chat_services.dart';

//Not needed for thhis week
class ProductsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductServices prodServices = ProductServices();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    prodServices.addToCart(
      context: context,
      product: widget.product,
    );
  }

  final ChatServices chatService = ChatServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(67),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(
                    left: 0,
                    top: 13,
                    right: 15,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(3),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.only(left: 13, top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Thrift-Exchange',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${widget.product.name}',
                      style: const TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Stars(rating: 3),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 20,
            //     horizontal: 10,
            //   ),
            //   child: Text(
            //     widget.product.name,
            //     style: const TextStyle(
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
            Container(
              color: Colors.black26,
              height: 6,
            ),
            CarouselSlider(
              items: widget.product.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 333,
              ),
            ),
            Container(
              color: Colors.black26,
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Item Price: ',
                  style: const TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 21,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Container(
            //   color: Colors.black12,
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Contact the Seller :',
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Hey, I am interested in this Product.',
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black38,
                    )),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black38,
                    ))),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter your Message';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    chatService.sendMessage(
                        context: context,
                        recipient: widget.product.email,
                        content: value);
                  }
                },
              ),
            ),
            // Container(
            //   color: Colors.black12,
            //   height: 3,
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 10, top: 15),
              child: CustomButton(text: 'Buy Now', onTap: () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 5, top: 5),
              child: CustomButton(text: 'Add to Cart', onTap: addToCart),
            ),
            Container(
              color: Colors.black12,
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Rate The Item: ',
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RatingBar.builder(
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.secondaryColor,
              ),
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(
              height: 13,
            ),
            Container(
              color: Colors.black26,
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
