import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../models/product.dart';
import '../services/cart_services.dart';
import 'package:flutter/services.dart';

enum CardType {
  Master,
  Visa,
  Verve,
  Discover,
  AmericanExpress,
  DinersClub,
  Jcb,
  Others,
  Invalid
}

class CheckoutScreen extends StatefulWidget {
  List<Product> products;
  CheckoutScreen({super.key, required this.products});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: {
      'query': query,
    });
  }
  final CartServices cartServices = CartServices();

  TextEditingController cardNumberController = TextEditingController();

  CardType cardType = CardType.Invalid;

  @override
  Widget build(BuildContext context) {
    num sum = 0;
    for (int i = 0; i < widget.products.length; i++){
      sum += widget.products[i].quantity * widget.products[i].price;
    }
    num salestax = sum * 0.08;
    num total = sum + salestax;


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
        padding: const EdgeInsets.all(20.0),

        child: 
          Column(
            children: [              
              const Text("Checkout",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: 
                  Column(children: [
                    Text("Subtotal: $sum",style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 5,
                    ),

                    Text("Sales Tax: $salestax",style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 5,
                    ),

                ]),
              ),
                            Align(
                alignment: Alignment.centerLeft,
                child: 
                  Column(children: [
                  Text("Total Price: $total",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
              ),


              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 10,
              ),
              Form(
                child: Container(
                  color: GlobalVariables.greyBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: cardNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(19),
                          ],
                          decoration: InputDecoration(hintText: "Card number"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(hintText: "Full name"),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Limit the input
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: const InputDecoration(hintText: "CVV"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                decoration:
                                    const InputDecoration(hintText: "MM/YY"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
              padding: const EdgeInsets.all(17),
              child: CustomButton(
                text: 'Checkout',
                onTap: () {
                    cartServices.checkoutCart(context: context);
                },
                color: const Color.fromARGB(255, 255, 208, 0),
              ),
            ),

            ],
          )
      ),
    );
  }
}
