import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/services/update_services.dart';

class UpdateDetails extends StatefulWidget {
  final String type;
  final Function() onSubmitted;
  const UpdateDetails({super.key, this.type = '', required this.onSubmitted});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final _updateFormKey = GlobalKey<FormState>();
  final UpdateService updateService = UpdateService();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _confirmValueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: GlobalVariables.backgroundColor,
      child: Form(
        key: _updateFormKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _valueController,
              hintText: widget.type,
            ),
            const SizedBox(
              height: 10,
            ),
            if (widget.type == 'password')
              CustomTextField(
                controller: _confirmValueController,
                hintText: "Re-type Password",
              ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: "Update",
              onTap: () {
                if (_updateFormKey.currentState!.validate()) {
                  if (widget.type == 'password' &&
                      _confirmValueController.text != _valueController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password doesn't match")));
                  } else {
                    widget.onSubmitted();
                    updateService.updateDetails(
                      context: context,
                      type: widget.type,
                      detail: _valueController.text,
                    );
                  }

                  //signUpUser();}
                }
              },
            )
          ],
        ),
      ),
    );
  }
}