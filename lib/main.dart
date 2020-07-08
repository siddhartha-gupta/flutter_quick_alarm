library quick_alarm;

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:circular_countdown/circular_countdown.dart';

part './AppConst.dart';
part './AppEvents.dart';
part './Scheduler.dart';
part './StorageService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  AppEvents.initialize();
  runApp(QuickAlarm());
}

class QuickAlarm extends StatefulWidget {
  @override
  QuickAlarmState createState() => QuickAlarmState();
}

class QuickAlarmState extends State<QuickAlarm> {
  ReceivePort receivePort = ReceivePort();
  StreamSubscription<String> alarmStateStream;
  String alarmState = 'NO_ALARM';

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, AppConst.MAIN_PORT_NAME);
    receivePort.listen((v) {
      Scheduler().buzzAlarm();
    });

    alarmStateStream = AppEvents.alarmState.listen((value) {
      setState(() {
        alarmState = value;
      });
    });
  }

  @override
  void dispose() {
    alarmStateStream.cancel();

    super.dispose();
  }

  List<Widget> showButtons() {
    List<Widget> widgetList = new List();

    if (alarmState == 'IN_PLACE') {
      var diff = (int.tryParse(StorageService.getItem('timestamp')) -
              new DateTime.now().millisecondsSinceEpoch) /
          1000;

      widgetList.add(
        Text(
          'Alarm already placed',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 30.0,
          ),
        ),
      );
      widgetList.add(
        new Padding(
          padding: EdgeInsets.only(
            bottom: 20,
          ),
        ),
      );
      widgetList.add(
        TimeCircularCountdown(
          unit: CountdownUnit.second,
          countdownTotal: diff.toInt(),
          diameter: 200,
          countdownCurrentColor: Colors.amber,
        ),
      );
    } else if (alarmState == 'BUZZING') {
      widgetList.add(RaisedButton(
        child: Icon(
          Icons.alarm_off,
          size: 100.0,
        ),
        onPressed: () {
          Scheduler().stopAlarm();
        },
        color: Colors.white,
      ));
      widgetList.add(
        new Text(
          'Stop alarm',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 40.0,
          ),
        ),
      );
    } else {
      widgetList.add(new RaisedButton(
        child: Icon(
          Icons.alarm,
          size: 100.0,
        ),
        onPressed: () {
          Scheduler().setupAlarm();
        },
        color: Colors.white,
      ));
      widgetList.add(
        new Text(
          'Setup alarm',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 40.0,
          ),
        ),
      );
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Quick alarm',
      home: new Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: showButtons(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
