import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sensors/sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '가속도 데이터 테스트',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '가속도 데이터 테스트'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double> _accelerometerValues = List<double>();
  List<double> _userAccelerometerValues = List<double>();
  List<double> _gyroscopeValues = List<double>();
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<FlSpot> _acc_X = List<FlSpot>();
  List<FlSpot> _acc_Y = List<FlSpot>();
  List<FlSpot> _acc_Z = List<FlSpot>();

  @override
  void initState(){
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      List<FlSpot> temp_X = List<FlSpot>(12);
      List<FlSpot> temp_Y = List<FlSpot>(12);
      List<FlSpot> temp_Z = List<FlSpot>(12);
      for(int i=1;i<12;i+=1){
        temp_X[i] = FlSpot(i.toDouble(), _acc_X[i-1].y);
        temp_Y[i] = FlSpot(i.toDouble(), _acc_Y[i-1].y);
        temp_Z[i] = FlSpot(i.toDouble(), _acc_Z[i-1].y);
      }
      temp_X[0] = FlSpot(0, event.x);
      temp_Y[0] = FlSpot(0, event.y);
      temp_Z[0] = FlSpot(0, event.z);
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
        _acc_X = temp_X;
        _acc_Y = temp_Y;
        _acc_Z = temp_Z;
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    for(double i=0;i<12;i+=1){
      _acc_X.add(FlSpot(i,0));
      _acc_Y.add(FlSpot(i,0));
      _acc_Z.add(FlSpot(i,0));
    }
  }

  Widget Chart2(){
    return SizedBox(
        width: 350,
        height: 340,
        child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: this._acc_X,
                  isCurved: true,
                  barWidth: 2,
                  colors: [
                    Colors.red,
                  ],
                  dotData: FlDotData(
                    show: true,
                  ),
                ),
                LineChartBarData(
                  spots: this._acc_Y,
                  isCurved: true,
                  barWidth: 2,
                  colors: [
                    Colors.blue,
                  ],
                  dotData: FlDotData(
                    show: true,
                  ),
                ),
                LineChartBarData(
                  spots: this._acc_Z,
                  isCurved: true,
                  barWidth: 2,
                  colors: [
                    Colors.green,
                  ],
                  dotData: FlDotData(
                    show: true,
                  ),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("accelerometer : ${accelerometer}"),
            Text("UserAccelerometer : ${userAccelerometer}"),
            Text("gyroscope : ${gyroscope}"),
            SizedBox(width: 10, height: 30),
            Chart2()
          ],
        ),
      ),
    );
  }
}
