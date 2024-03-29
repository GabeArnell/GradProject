import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/services/update_services.dart';
import 'package:thrift_exchange/features/auth/services/auth_service.dart';
import 'package:thrift_exchange/features/home/screens/home_screens.dart';
import 'package:thrift_exchange/features/home/screens/products_screens.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import 'package:thrift_exchange/features/home/services/home_services.dart';
import 'package:thrift_exchange/models/order.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../models/user.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final HomeServices adminServices = HomeServices();
  final AuthService authService = AuthService();

  UpdateService updateService = UpdateService();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  late User buyerData = User(id: "loading", 
  name: "loading", 
  password: "loading", 
  email: "loading", 
  address: "loading", 
  type: "loading", 
  image: "loading", 
  token: "loading", 
  cart: [], 
  usedPromotions: []);


  String orderStatus = "Loading";
  

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
    loadBuyer();
  }

  void loadBuyer()async{
    buyerData = await authService.adminUserSearch(context: context, userID: widget.order.userId);
    setState(() {
      
    });
  }

  void updateOrderStatus(int newStatus )async{
    updateService.updateOrderStatus(context: context, order: widget.order, newStatus: newStatus);
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    print("Order status is ${widget.order.status}");
    if (widget.order.status == 0){
      orderStatus = "Processing";
    }
    if (widget.order.status == 1){
      orderStatus = "Shipping";
    }
    if (widget.order.status == 2){
      orderStatus = "Delivered";
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              user.type == "Admin"?"Active Order":"Your Order",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                " Order details",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.type == "Admin")
                      Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Buyer: ${buyerData.email}",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),



                    Text("Order Date: ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}"),
                    Text('Order ID: ${widget.order.id}'),
                    Text('Order Total: \$${widget.order.totalPrice.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Purchased",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (int i = 0; i < widget.order.products.length; i++)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductsScreen.routeName,
                            arguments: widget.order.products[i],
                          );
                        },
                        child: Row(
                          children: [
                            Image.network(
                              widget.order.products[i].images[0],
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: ${widget.order.quantity[i].toString()}',
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Order Status: ",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          user.type =="Admin"?"The Order is: ":"Your Order is: ",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          orderStatus,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (user.type == "Admin")
              Container(
                child: Column(children: [
                  SizedBox(
                    height: 25,
                  ),
                    Text(
                        "Admin: Set Order Status",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListTile(
                    
                      title: const Text("Processing",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          )),
                      tileColor: 1 == 1
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: "Processing",
                        groupValue: orderStatus,
                        onChanged: (String? val) {
                          setState(() {
                            widget.order.status = 0;
                            orderStatus = val!;
                          });
                          updateOrderStatus(0);
                        },
                      ),
                    ),
                    ListTile(
                    
                      title: const Text("Shipping",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          )),
                      tileColor: 1 == 1
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: "Shipping",
                        groupValue: orderStatus,
                        onChanged: (String? val) {
                          setState(() {
                            widget.order.status = 1;
                            orderStatus = val!;
                          });
                          updateOrderStatus(1);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Delivered",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          )),
                      tileColor: 1 == 1
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: "Delivered",
                        groupValue: orderStatus,
                        onChanged: (String? val) {
                          setState(() {
                            widget.order.status = 2;
                            orderStatus = val!;
                          });
                          updateOrderStatus(2);

                        },
                      ),
                    ),

                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'View order details',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black12,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Order Date:      ${DateFormat().format(
//                       DateTime.fromMillisecondsSinceEpoch(
//                           widget.order.orderedAt),
//                     )}'),
//                     Text('Order ID:          ${widget.order.id}'),
//                     Text('Order Total:      \$${widget.order.totalPrice}'),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Purchase Details',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black12,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     for (int i = 0; i < widget.order.products.length; i++)
//                       Row(
//                         children: [
//                           Image.network(
//                             widget.order.products[i].images[0],
//                             height: 120,
//                             width: 120,
//                           ),
//                           const SizedBox(width: 5),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.order.products[i].name,
//                                   style: const TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Text(
//                                   'Qty: ${widget.order.quantity[i]}',
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Tracking',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black12,
//                   ),
//                 ),
//                 child: Stepper(
//                   currentStep: currentStep,
//                   controlsBuilder: (context, details) {
//                     if (user.type == 'admin') {
//                       return CustomButton(
//                         text: 'Done',
//                         onTap: () => changeOrderStatus(details.currentStep),
//                       );
//                     }
//                     return const SizedBox();
//                   },
//                   steps: [
//                     Step(
//                       title: const Text('Pending'),
//                       content: const Text(
//                         'Your order is yet to be delivered',
//                       ),
//                       isActive: currentStep > 0,
//                       state: currentStep > 0
//                           ? StepState.complete
//                           : StepState.indexed,
//                     ),
//                     Step(
//                       title: const Text('Completed'),
//                       content: const Text(
//                         'Your order has been delivered, you are yet to sign.',
//                       ),
//                       isActive: currentStep > 1,
//                       state: currentStep > 1
//                           ? StepState.complete
//                           : StepState.indexed,
//                     ),
//                     Step(
//                       title: const Text('Received'),
//                       content: const Text(
//                         'Your order has been delivered and signed by you.',
//                       ),
//                       isActive: currentStep > 2,
//                       state: currentStep > 2
//                           ? StepState.complete
//                           : StepState.indexed,
//                     ),
//                     Step(
//                       title: const Text('Delivered'),
//                       content: const Text(
//                         'Your order has been delivered and signed by you!',
//                       ),
//                       isActive: currentStep >= 3,
//                       state: currentStep >= 3
//                           ? StepState.complete
//                           : StepState.indexed,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
