import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/constants/global_variables.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();

  String category = 'Apparel';
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    zipcodeController.dispose();
  }

  List<String> productCategories = [
    'Electronics',
    'Appliances',
    'Apparel',
    'Furniture',
    'Other'
  ];

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
              'Add Product',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [
              const SizedBox(
                height: 21,
              ),
              Container(
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
              const SizedBox(
                height: 33,
              ),
              CustomTextField(
                controller: productNameController,
                hintText: 'Product Name',
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Description',
                maxLines: 8,
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: priceController,
                hintText: 'Price',
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: quantityController,
                hintText: 'quantity',
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                controller: zipcodeController,
                hintText: 'Zipcode',
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
                onTap: () {},
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
