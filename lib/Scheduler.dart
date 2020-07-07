part of quick_alarm;

class Scheduler {
  setupAlarm() async {
    print('Setting up alarm!');
    AppEvents.setAlarmState('IN_PLACE');

    final success = await AndroidAlarmManager.oneShot(
        Duration(seconds: 3), 42, callback,
        wakeup: true, exact: true);
    print(success);
  }

  static callback() async {
    SendPort sendPort = IsolateNameServer.lookupPortByName('MyAppPort');
    if (sendPort != null) {
      sendPort.send("DONE");
    }
  }

  buzzAlarm() {
    AppEvents.setAlarmState('BUZZING');

    FlutterRingtonePlayer.playRingtone(
      looping: true,
      volume: 1.0,
      asAlarm: true,
    );
  }

  stopAlarm() {
    AppEvents.setAlarmState('NO_ALARM');

    FlutterRingtonePlayer.stop();
  }
}
