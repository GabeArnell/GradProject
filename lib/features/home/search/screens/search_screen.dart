import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/loader.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/widgets/address_box.dart';
import 'package:thrift_exchange/features/home/screens/products_screens.dart';
import 'package:thrift_exchange/features/home/search/services/search_services.dart';
import 'package:thrift_exchange/features/home/search/widgets/searched_product.dart';
import 'package:thrift_exchange/features/home/widgets/search_filter.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  final String category;
  final String zipcode;
  const SearchScreen({
    Key? key,
    required this.searchQuery,
    required this.category,
    required this.zipcode,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  String _selectedCategory = 'All';
  String _selectedZipcode = '0';

  final SearchServices searchServices = SearchServices();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: {
      'query': query,
      'category': _selectedCategory,
      'zipcode': _selectedZipcode,
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _selectedZipcode = widget.zipcode;
    fetchSearchedProduct();
  }

  fetchSearchedProduct() async {
    products = await searchServices.fetchSearchedProduct(
      context: context,
      searchQuery: widget.searchQuery,
      category: widget.category,
      zipcode: widget.zipcode,
    );
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 0),
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
                        contentPadding: const EdgeInsets.only(left: 13),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
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
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ],
          ),
        ),
      ),
      body: products == null
          ? const Loader()
          : Column(
              children: [
                SearchFilter(
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  onZipcodeUpdated: (zipcode) {
                    setState(() {
                      _selectedZipcode = zipcode;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductsScreen.routeName,
                            arguments: products![index],
                          );
                        },
                        child: SearchedProduct(
                          product: products![index],
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
