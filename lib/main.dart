library quick_alarm;

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

part './AppConst.dart';
part './AppEvents.dart';
part 'services/SchedulerService.dart';
part 'services/StorageService.dart';
part 'widgets/CountDownWidget.dart';
part 'widgets/AlarmInPlaceWidget.dart';
part 'widgets/SetupAlarmWidget.dart';
part 'widgets/StopAlarmWidget.dart';

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
  ReceivePort receivePort1 = ReceivePort();
  StreamSubscription<String> alarmStateStream;
  String alarmState = 'NO_ALARM';

  @override
  void initState() {
    super.initState();

    SchedulerService().cleanUp();

    IsolateNameServer.registerPortWithName(
        receivePort1.sendPort, AppConst.MAIN_PORT_NAME);

    receivePort1.listen((v) {
      SchedulerService().buzzAlarm();
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

  Widget showButtons() {
    switch (alarmState) {
      case 'IN_PLACE':
        return new AlarmInPlaceWidget();

      case 'BUZZING':
        return new StopAlarmWidget();

      default:
        return new SetupAlarmWidget();
    }
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
              showButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
