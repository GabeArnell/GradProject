import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/loader.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/services/editing_service.dart';
import 'package:thrift_exchange/features/account/widgets/posting_item.dart';
import 'package:thrift_exchange/features/home/screens/products_screens.dart';
import 'package:thrift_exchange/models/product.dart';

import '../widgets/edit_product.dart';

class PostingsPage extends StatefulWidget {
  static const String routeName = '/show-postings';
  const PostingsPage({super.key});

  @override
  State<PostingsPage> createState() => _PostingsPageState();
}

class _PostingsPageState extends State<PostingsPage> {
  List<Product>? postings;
  EditingService editingServices = EditingService();
  @override
  void initState() {
    super.initState();
    fetchPostings();
  }

  fetchPostings() async {
    postings = await editingServices.getPostings(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(
              left: 3.0,
              right: 13,
              top: 3,
            ),
            child: Text(
              "Your Postings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 22.6,
              ),
            ),
          ),
        ),
      ),
      body: postings == null
          ? const Loader()
          : Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: postings!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            EditProductPage.routeName,
                            arguments: postings![index],
                          );
                        },
                        child: PostingItem(
                          product: postings![index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
