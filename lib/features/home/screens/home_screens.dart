import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/loader.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/widgets/product.dart';
import 'package:thrift_exchange/features/home/screens/add_product_Screen.dart';
import 'package:thrift_exchange/features/home/screens/add_reminder_screen.dart';
import 'package:thrift_exchange/features/home/screens/category_screen.dart';
import 'package:thrift_exchange/features/home/screens/products_screens.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import 'package:thrift_exchange/features/home/services/home_services.dart';
import 'package:thrift_exchange/features/home/widgets/category.dart';
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
  List<String> categories = [
    'All',
    'Electronics',
    'Appliances',
    'Apparel',
    'Furniture',
    'Other'
  ];
  List<String> categoryImage = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMidast3-DfnTuLTwez1EOGXrU63x6_q8X7w&usqp=CAU',
    'https://static.vecteezy.com/system/resources/previews/003/769/924/non_2x/electronics-and-accessories-pink-flat-design-long-shadow-glyph-icon-smartphone-and-laptop-computers-and-devices-e-commerce-department-online-shopping-categories-silhouette-illustration-vector.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvz9dzpMsM_z0l2jfnXApB4sj7j9_Ic7dk1w&usqp=CAU',
    'https://cdn0.iconfinder.com/data/icons/shopping-and-commerce-2-12/66/84-512.png',
    'https://i.pinimg.com/564x/13/8d/74/138d740b0d523e8635ad851510f0a789.jpg',
    'https://cdn1.iconfinder.com/data/icons/branding-filledoutline/64/BADGE-branding-pin-miscellaneous-badges-shapes-512.png'
  ];
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

  void navigateToAddNotificationScreen() {
    Navigator.pushNamed(context, AddAlertScreen.routeName);
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
                        if (user.type == "Admin")
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: const Text(
                              "Admin",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        if (user.type != "Admin")
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: IconButton(
                              onPressed: navigateToAddNotificationScreen,
                              icon: const Icon(
                                Icons.notifications_active,
                              ),
                            ),
                          )
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (user.type != "Admin")
                    SearchFilter(
                      onCategorySelected: (category) {
                        _selectedCategory = category;
                      },
                      onZipcodeUpdated: (zipcode) {
                        _selectedZipcode = zipcode;
                      },
                    ),
                  if (user.type != "Admin")
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 15,
                        bottom: 15,
                      ),
                      child: Center(
                        child: const Text(
                          "Today's Deal",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (user.type != "Admin")
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7WnMwWXltBo_XSSTd0bNHBVhX1kwCS5zqgA&usqp=CAU',
                        height: 235,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  if (user.type != "Admin")
                    Padding(
                      padding: const EdgeInsets.all(21),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Categories',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  if (user.type != "Admin")
                    GridView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CategoryProducts.routeName,
                                arguments: categories[index]);
                          },
                          child: CategoryWidget(
                            image: categoryImage[index],
                            category: categories[index],
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.all(21),
                    child: RichText(
                      text: TextSpan(
                        text: (user.type == "Admin") ? 'All Posts' : 'Products',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    itemCount: products!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                                if (productData.email == user.email ||
                                    user.type == "Admin")
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
                ],
              ),
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
