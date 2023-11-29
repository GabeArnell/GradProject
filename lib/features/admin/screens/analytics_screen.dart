import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/loader.dart';
import 'package:thrift_exchange/features/admin/models/sales_model.dart';
import 'package:thrift_exchange/features/admin/services/admin_services.dart';
import 'package:thrift_exchange/features/admin/widgets/category_charts.dart';
import 'package:charts_flutter_maintained/charts_flutter_maintained.dart'
    as charts;

import '../models/views_model.dart';
import '../widgets/category_view_charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;
  int? totalViews;
  List<Views>? views;

  @override
  void initState() {
    super.initState();
    getEarnings();
    getViews();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
  }

  getViews() async {
    var viewData = await adminServices.getViews(context);
    totalViews = viewData['totalViews'];
    views = viewData['views'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Sales Analytics',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Text(
                  '\$$totalSales',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryProductsChart(seriesList: [
                      charts.Series(
                        id: 'Sales',
                        data: earnings!,
                        domainFn: (Sales sales, _) => sales.label,
                        measureFn: (Sales sales, _) => sales.earnings,
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Views Analytics',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Text(
                  '$totalViews Total',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryViewChart(seriesList: [
                      charts.Series(
                        id: 'Views',
                        data: views!,
                        domainFn: (Views views, _) => views.label,
                        measureFn: (Views views, _) => views.views,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
  }
}
