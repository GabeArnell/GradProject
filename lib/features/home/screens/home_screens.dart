import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/loader.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/widgets/product.dart';
import 'package:thrift_exchange/features/home/screens/add_product_Screen.dart';
import 'package:thrift_exchange/features/home/screens/products_screens.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import 'package:thrift_exchange/features/home/services/home_services.dart';
import 'package:thrift_exchange/features/home/widgets/search_filter.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _selectedZipcode = '0';
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: {
      'query': query,
      'category': _selectedCategory,
      'zipcode': _selectedZipcode,
    });
  }

  List<Product>? products = [];
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    products = (await homeServices.fetchAllProducts(context)).cast<Product>();
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    homeServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    _selectedZipcode = user.address;
    return products == null
        ? const Loader()
        : Scaffold(
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
            // body: const Column(
            //   children: [
            //     //const AddressBox(),
            //   ],
            // ),
            body: Column(
              children: [
                SearchFilter(
                  onCategorySelected: (category) {
                    _selectedCategory = category;
                  },
                  onZipcodeUpdated: (zipcode) {
                    _selectedZipcode = zipcode;
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: products!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final productData = products![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductsScreen.routeName,
                            arguments: productData,
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 140,
                              child: ProductW(image: productData.images[0]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 13.0),
                                    child: Text(
                                      productData.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      deleteProduct(productData, index),
                                  icon: const Icon(Icons.delete_sharp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: navigateToAddProduct,
              tooltip: 'Add a Product',
              child: const Icon(
                Icons.add,
              ),
              splashColor: Colors.orange,
            ),
          );
  }
}
