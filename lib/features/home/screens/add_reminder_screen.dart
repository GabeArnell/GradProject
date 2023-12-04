import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/home/screens/home_screens.dart';
import 'package:thrift_exchange/features/home/search/widgets/saved_alert.dart';
import 'package:thrift_exchange/features/home/services/home_services.dart';

import '../../../models/alert.dart';

class AddAlertScreen extends StatefulWidget {
  static const String routeName = "/set-alert";
  const AddAlertScreen({super.key});

  @override
  State<AddAlertScreen> createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends State<AddAlertScreen> {
  final _addAlertFormKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  HomeServices homeServices = HomeServices();
  String category = 'Apparel';
  List<String> productCategories = [
    'Electronics',
    'Appliances',
    'Apparel',
    'Furniture',
    'Other'
  ];
  Future<bool> submitAlert() async{
    if (_addAlertFormKey.currentState!.validate()) {
      await homeServices.submitAlert(
        context: context,
        name: productNameController.text,
        zipcode: (zipcodeController.text).trim(),
        category: category,
      );
    }
    loadAlerts();
    return true;
  }

  List<Alert> alertList = [];

  @override
  void initState(){
    super.initState();
    loadAlerts();
  }

  void loadAlerts()async{
    alertList = await homeServices.getAlerts(context: context);
    setState(() {
      
    });
  }

  void deleteAlert(Alert alert)async{
    print("Deleting alert: "+alert.name);
    bool result = await homeServices.deleteAlert(context: context, alert: alert);
    loadAlerts();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: const Text(
          "Set Product Alert",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Form(
            key: _addAlertFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                children: [
                  const SizedBox(
                    height: 21,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Can't find what you're looking for?\nSet an alert describing what you need and we will notify you when it is in stock",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 21,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Text(
                    "Enter the details : \n",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                  CustomTextField(
                    controller: productNameController,
                    hintText: 'Product Name',
                  ),
                  const SizedBox(
                    height: 17,
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
                  CustomButton(text: 'Submit', onTap:()async{
                    var result = await submitAlert();
                    setState(() {
                    });

                  } ),
                  const SizedBox(
                    height: 15,
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "Currently Set Alerts",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 21,
                fontStyle: FontStyle.italic),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                        itemCount: alertList.length,
                        itemBuilder: (context, index) {
                          return SavedAlert(alert: alertList[index], deleteFunction: deleteAlert,);
                        },
                      ),
            ),
          ),
        
        ],
      ),
    );
  }
}
