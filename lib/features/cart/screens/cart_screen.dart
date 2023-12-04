import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/cart/screens/checkout_screen.dart';
import 'package:thrift_exchange/features/cart/widgets/cart_product.dart';
import 'package:thrift_exchange/features/cart/widgets/cart_subtotal.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../constants/utils.dart';
import '../../../models/product.dart';
import '../services/cart_services.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: {
      'query': query,
    });
  }

  final CartServices cartServices = CartServices();

  List<Product> products = [];
  void initState() {
    super.initState();
    loadCart();
  }
  String formatMoney(num m){
    int expand = (m*100).round();
    String result = "${expand/100}";
    return result;
  }

  void loadCart() async {
    products = (await cartServices.fetchCartProducts(context)).cast<Product>();

    setState(() {});
  }

  Future<List<dynamic>> calculateTaxes()async{
    List<dynamic> taxList = await cartServices.getTaxList(context: context, products: products);
    return taxList;
  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    num userCartLength = 0;
    for (int i = 0; i < context.watch<UserProvider>().user.cart.length; i++) {
      userCartLength += context.watch<UserProvider>().user.cart[i]['quantity'];
    }
    CartSubtotal subtotalScreen = CartSubtotal(products: products);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(67),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          elevation: 0,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(
                        left: 15,
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
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            subtotalScreen,
            Padding(
              padding: const EdgeInsets.all(17),
              child: CustomButton(
                text: 'Proceed to Buy (${userCartLength} items)',
                onTap: () async {
                  if (userCartLength > 0) {
                    if (user.address.isEmpty){
                      showSnackBar(context, 'Set an address in your profile before checking out!');
                      return;
                    }
                    List<dynamic> taxes = await calculateTaxes();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CheckoutScreen(products: products, promoCode: subtotalScreen.promoCode,postPromoSum: subtotalScreen.postPromoSum,
                        taxList: taxes,
                      );
                    }));
                  }
                },
                color: Colors.yellow[600],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black12.withOpacity(0.13),
              height: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(index: index, product: products[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
