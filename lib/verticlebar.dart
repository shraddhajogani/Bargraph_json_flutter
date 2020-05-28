import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Calculation, String>> seriesBarData;

  _generateData() async {
    final load =
        await DefaultAssetBundle.of(context).loadString("asset/data.json");

    var decoded = json.decode(load);
    List<Calculation> chartdata = [];
    for (var item in decoded) {
      chartdata.add(Calculation.fromJson(item));
    }

    seriesBarData.add(charts.Series(
      data: chartdata,
      //domainFn: (Calculation chartdata, _) => int.parse(chartdata.time),
      domainFn: (Calculation chartdata, _) => chartdata.time,
      measureFn: (Calculation chartdata, _) => int.parse(chartdata.distance),
      // measureFn: (Calculation chartdata, _) => chartdata.distance,
      id: 'Performance',
    ));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    seriesBarData = List<charts.Series<Calculation, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(child: Text('flutter charts')),
      ),
      body: Column(
        children: [
          Text(
            'Distance to Lane',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          if (seriesBarData.length > 0)
            Expanded(
              child: charts.BarChart(
                seriesBarData,
                animate: true,
                animationDuration: Duration(seconds: 5),
                // domainAxis: new charts.OrdinalAxisSpec(
                //viewport: new charts.OrdinalViewport('AePS', 9),
                // ),
                behaviors: [
                  new charts.ChartTitle('Time,seconds',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      // titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 11),
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea),
                  new charts.ChartTitle('Distance,Meter',
                      behaviorPosition: charts.BehaviorPosition.start,
                      // titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 11),
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea),
                  // new charts.DatumLegend(),
                  // new charts.BarLabelDecorator<List>()
                ],
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }
}

class Calculation {
  String time;
  String distance;

  Calculation(this.time, this.distance);

  Calculation.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    distance = json['distance'];
  }
}
//Calculation.fromJson(Map<String, dynamic> json)
// new Map<String, dynamic>.from(snapshot.value);
//final chartdata = List<dynamic>.from(
//      chartdata.map<dynamic>(
//            (dynamic item) => item,
//      ),
//    );
