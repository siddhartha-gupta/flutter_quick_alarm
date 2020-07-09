part of quick_alarm;

class AppEvents {
  static PublishSubject<String> alarmState;
  static PublishSubject<int> countdownTimer;

  static void initialize() {
    alarmState = new PublishSubject<String>();
    countdownTimer = new PublishSubject<int>();

    StorageService.initialize().then((value) {
      AppEvents.setAlarmState(
          StorageService.getString('alarmState') ?? 'NO_ALARM');
    });
  }

  static void setAlarmState(String state) {
    alarmState.add(state);
    StorageService.setString('alarmState', state);
  }

  static void setTimer(String data) {
    countdownTimer.add(int.tryParse(data));
  }
}
