import 'package:charts_flutter_maintained/charts_flutter_maintained.dart'
    as charts;
import 'package:flutter/material.dart';

import '../models/views_model.dart';

class CategoryViewChart extends StatelessWidget {
  final List<charts.Series<Views, String>> seriesList;
  const CategoryViewChart({
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
