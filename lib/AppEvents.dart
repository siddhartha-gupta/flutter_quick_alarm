part of quick_alarm;

class AppEvents {
  static PublishSubject<String> alarmState;

  static void initialize() {
    alarmState = new PublishSubject<String>();

    StorageService.initialize().then((value) {
      AppEvents.setAlarmState(
          StorageService.getItem('alarmState') ?? 'NO_ALARM');
    });
  }

  static void setAlarmState(String state) {
    alarmState.add(state);
    StorageService.setItem('alarmState', state);
  }
}
