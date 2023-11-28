import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/loader.dart';
import 'package:thrift_exchange/features/account/screens/order_details.dart';
import 'package:thrift_exchange/features/account/services/update_services.dart';
import 'package:thrift_exchange/features/account/widgets/product.dart';
import 'package:thrift_exchange/models/order.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/order-screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  UpdateService updateService = UpdateService();
  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  fetchOrders() async {
    orders = await updateService.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: (user.type != 'Admin')
          ? AppBar(
              title: Text(
                'Orders',
                style: TextStyle(color: Colors.black),
              ),
            )
          : null,
      body: orders == null
          ? const Loader()
          : GridView.builder(
              itemCount: orders!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final orderData = orders![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailScreen.routeName,
                        arguments: orderData);
                  },
                  child: SizedBox(
                    height: 130,
                    child: ProductW(image: orderData.products[0].images[0]),
                  ),
                );
              },
            ),
    );
  }
}
