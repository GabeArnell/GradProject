import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/stars.dart';
import 'package:thrift_exchange/models/product.dart';

import '../../../../constants/global_variables.dart';
import '../../../../models/alert.dart';

class SavedAlert extends StatelessWidget {
  final Alert alert;

  final Function deleteFunction;
  const SavedAlert({
    Key? key,
    required this.alert, required this.deleteFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top:10,left: 10, right: 10),

          color: GlobalVariables.greyBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Alerting for: "${alert.name}" (${alert.category})',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'In zipcode: ${alert.zipcode}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete"),
                    subtitle: Text(''),
                    onTap: () {
                      deleteFunction(alert);
                    },
                  ),
            
                      
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
