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

  Widget showButton() {
    if (alarmState == 'IN_PLACE') {
      return Text('Alarm already placed');
    }

    if (alarmState == 'BUZZING') {
      return new RaisedButton(
        child: Icon(
          Icons.alarm_off,
          size: 100.0,
        ),
        onPressed: () {
          Scheduler().stopAlarm();
        },
        color: Colors.white,
      );
    }

    return new RaisedButton(
      child: Icon(
        Icons.alarm,
        size: 100.0,
      ),
      onPressed: () {
        Scheduler().setupAlarm();
      },
      color: Colors.white,
    );
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
              Expanded(
                // 1st use Expanded
                child: Center(
                  child: showButton(),
                ), // 2nd wrap your widget in Center
              ),
            ],
          ),
        ),
      ),
    );
  }
}
