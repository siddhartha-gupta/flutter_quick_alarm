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

    IsolateNameServer.registerPortWithName(receivePort.sendPort, 'MyAppPort');
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
      widgetList.add(
        Text(
          'Alarm already placed',
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
