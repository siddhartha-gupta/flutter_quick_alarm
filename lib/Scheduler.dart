part of quick_alarm;

class Scheduler {
  setupAlarm() async {
    print('Setting up alarm!');
    var minutes = AppConst.TIMER_MINUTES;
    var timstamp = new DateTime.now()
        .add(Duration(minutes: minutes))
        .millisecondsSinceEpoch;

    AppEvents.setAlarmState('IN_PLACE');
    StorageService.setItem('timestamp', timstamp.toString());

    final success = await AndroidAlarmManager.oneShot(
      Duration(minutes: minutes),
      42,
      callback,
      wakeup: true,
      exact: true,
    );
    print(success);
  }

  static callback() async {
    SendPort sendPort =
        IsolateNameServer.lookupPortByName(AppConst.MAIN_PORT_NAME);
    if (sendPort != null) {
      sendPort.send("DONE");
    }
  }

  buzzAlarm() {
    AppEvents.setAlarmState('BUZZING');

    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
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
