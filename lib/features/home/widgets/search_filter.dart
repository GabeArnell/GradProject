import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

enum CategoryFilter { Electronics, Appliances, Apparel, Furniture, Other, All }

class SearchFilter extends StatefulWidget {
  final Function(String) onCategorySelected;
  final Function(String) onZipcodeUpdated;
  const SearchFilter(
      {super.key,
      required this.onCategorySelected,
      required this.onZipcodeUpdated});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  String? zipcodeError;

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
  }

  CategoryFilter _category = CategoryFilter.All;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return GestureDetector(
      onTap: (() {
        setState(() {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              _category = CategoryFilter.All;
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateModal) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 30)),
                        const Text("Search Filter",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Categories",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        ListTile(
                          title: const Text("All",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          tileColor: GlobalVariables.backgroundColor,
                          leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: CategoryFilter.All,
                            groupValue: _category,
                            onChanged: (CategoryFilter? val) {
                              setStateModal(() {
                                _category = val!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Electronics",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          tileColor: GlobalVariables.backgroundColor,
                          leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: CategoryFilter.Electronics,
                            groupValue: _category,
                            onChanged: (CategoryFilter? val) {
                              setStateModal(() {
                                _category = val!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Appliances",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          tileColor: GlobalVariables.backgroundColor,
                          leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: CategoryFilter.Appliances,
                            groupValue: _category,
                            onChanged: (CategoryFilter? val) {
                              setStateModal(() {
                                _category = val!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Apparel",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          tileColor: GlobalVariables.backgroundColor,
                          leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: CategoryFilter.Apparel,
                            groupValue: _category,
                            onChanged: (CategoryFilter? val) {
                              setStateModal(() {
                                _category = val!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Furniture",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          tileColor: GlobalVariables.backgroundColor,
                          leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: CategoryFilter.Furniture,
                            groupValue: _category,
                            onChanged: (CategoryFilter? val) {
                              setStateModal(() {
                                _category = val!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Other",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          tileColor: GlobalVariables.backgroundColor,
                          leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: CategoryFilter.Other,
                            groupValue: _category,
                            onChanged: (CategoryFilter? val) {
                              setStateModal(() {
                                _category = val!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Zipcode",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              children: [
                                CustomTextField(
                                    controller: addressController,
                                    hintText: user.address == ''
                                        ? 'Zipcode'
                                        : user.address),
                                if (zipcodeError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      zipcodeError!,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: CustomButton(
                              text: 'Submit',
                              onTap: () {
                                if (RegExp(r'^\d+$').hasMatch(addressController.text) || addressController.text.isEmpty) {
                                  print("Matched the regex");
                                  widget.onCategorySelected(_category.toString().split('.').last);
                                  widget.onZipcodeUpdated(addressController.text.trim());
                                  Navigator.pop(context);
                                } else {
                                  setStateModal(() {
                                    zipcodeError =
                                        "Enter only numeric values in Zipcode";
                                  });
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                );
              });
            },
          );
        });
      }),
      child: Container(
        height: 39,
        decoration: const BoxDecoration(
          gradient: GlobalVariables.appBarGradient,
        ),
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            const Icon(
              Icons.search_sharp,
              size: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  'Search Filter',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 5,
                top: 2,
              ),
              child: Icon(
                Icons.arrow_drop_down_outlined,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
