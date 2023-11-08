import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/home/screens/home_screens.dart';
import 'package:thrift_exchange/features/home/services/home_services.dart';
import 'package:thrift_exchange/models/product.dart';

class EditProductPage extends StatefulWidget {
  static const String routeName = '/edit-product';
  final Product product;
  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final HomeServices homeServices = HomeServices();

  String category = 'Apparel';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    zipcodeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    category = widget.product.category; // This is okay
  }

  List<String> productCategories = [
    'Electronics',
    'Appliances',
    'Apparel',
    'Furniture',
    'Other'
  ];

  void submitProduct(String id) {
      if (priceController.text.isEmpty){
        priceController.text = "-1";
      }
      if (quantityController.text.isEmpty){
        quantityController.text = "-1";
      }
      if (zipcodeController.text.isEmpty){
        zipcodeController.text = "0";
      }
      homeServices.editProduct(
        id: id,
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        zipcode: double.parse(zipcodeController.text),
        category: category,
        images: images,
      );
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Editted product")));

    Navigator.pop(context);
    Navigator.pop(context);
  }

  void generateDescription() async {
    if (productNameController.text.isNotEmpty) {
      String response = await homeServices.descriptionHelp(
          context: context,
          name: productNameController.text,
          description: descriptionController.text,
          price: priceController.text);
      if (response != 'Could not connect to Service') {
        descriptionController.text = response;
      }
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

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
          title: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: const Text(
              'Edit Product',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _addProductFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [
              const SizedBox(
                height: 21,
              ),
              images.isNotEmpty
                  ? CarouselSlider(
                      items: images.map(
                        (i) {
                          return Builder(
                            builder: (BuildContext context) => Image.file(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        },
                      ).toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 200,
                      ),
                    )
                  : GestureDetector(
                      onTap: selectImages,
                      child: Container(
                        //margin: EdgeInsets.only(top:21,left: 15, right: 15),
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder_open,
                              size: 39,
                            ),
                            Text(
                              'Select Product Images to Upload',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(
                height: 33,
              ),
              CustomTextField(
                controller: productNameController,
                hintText: "Name: ${widget.product.name}",
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: descriptionController,
                hintText: "Description: ${widget.product.description}",
                maxLines: 8,
              ),
              const SizedBox(
                height: 13,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: priceController,
                hintText: "Price: ${widget.product.price}",
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: quantityController,
                hintText: "Quantity: ${widget.product.quantity}",
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: zipcodeController,
                hintText: "Zip Code: ${widget.product.zipcode}",
              ),
              const SizedBox(
                height: 13,
              ),
              SizedBox(
                height: 39,
                child: DropdownButton(
                  items: productCategories.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  value: category,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  onChanged: (String? newVal) {
                    setState(() {
                      category = newVal!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Submit',
                onTap: (){
                  submitProduct(widget.product.id!);
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      )),
    );
  }
}