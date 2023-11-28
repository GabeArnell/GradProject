import 'package:charts_flutter_maintained/charts_flutter_maintained.dart'
    as charts;
import 'package:flutter/material.dart';
import 'package:thrift_exchange/features/admin/models/sales_model.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<charts.Series<Sales, String>> seriesList;
  const CategoryProductsChart({
    Key? key,
    required this.seriesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
