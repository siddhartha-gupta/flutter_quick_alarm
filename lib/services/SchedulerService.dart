part of quick_alarm;

class SchedulerService {
  setupAlarm(int val) async {
    print('Setting up alarm!');

    int timer = DateTime.now().millisecondsSinceEpoch + (val * 60 * 1000);

    AppEvents.setAlarmState('IN_PLACE');
    StorageService.setInteger('timestamp', timer);
    StorageService.setInteger('currentTimerMinutes', val);

    await AndroidAlarmManager.oneShot(
      Duration(minutes: val),
      AppConst.MAIN_PORT_ID,
      callback,
      wakeup: true,
      exact: true,
    );
  }

  static callback() async {
    SendPort sendPort =
        IsolateNameServer.lookupPortByName(AppConst.MAIN_PORT_NAME);

    if (sendPort != null) {
      sendPort.send('DONE');
    }
  }

  buzzAlarm() {
    print('buzzAlarm');

    AppEvents.setAlarmState('BUZZING');
    StorageService.setInteger('timestamp', 0);

    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true,
      volume: 1.0,
      asAlarm: true,
    );
  }

  stopAlarm() {
    print('stopAlarm');

    AppEvents.setAlarmState('NO_ALARM');
    FlutterRingtonePlayer.stop();
  }

  cancelAlarm() {
    print('cancelAlarm');

    AndroidAlarmManager.cancel(AppConst.MAIN_PORT_ID);
    StorageService.setInteger('timestamp', 0);
    AppEvents.setAlarmState('NO_ALARM');
  }

  cleanUp() {
    print('cleanUp');

    int timestamp = StorageService.getInteger('timestamp') ?? 0;

    if (timestamp > 0 && timestamp < DateTime.now().millisecondsSinceEpoch) {
      AppEvents.setAlarmState('NO_ALARM');
      StorageService.setInteger('timestamp', 0);
    }
  }
}
