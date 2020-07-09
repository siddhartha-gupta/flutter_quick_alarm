part of quick_alarm;

class SchedulerService {
  setupAlarm() async {
    print('Setting up alarm!');

    AppEvents.setAlarmState('IN_PLACE');
    CountDownService.start();

    final success = await AndroidAlarmManager.oneShot(
      Duration(minutes: AppConst.TIMER_MINUTES),
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
      sendPort.send('DONE');
    }
  }

  buzzAlarm() {
    AppEvents.setAlarmState('BUZZING');
    CountDownService.stop();

    print('buzzAlarm');
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
    print('stopAlarm');

    FlutterRingtonePlayer.stop();
  }
}
