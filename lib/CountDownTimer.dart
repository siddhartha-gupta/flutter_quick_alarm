part of quick_alarm;

class CountDownTimer {
  static Isolate isolate;
  static ReceivePort receivePort;

  static void start() async {
    // StorageService.setItem('timestamp', timstamp.toString());
    CountDownTimer.receivePort = ReceivePort();
    CountDownTimer.isolate = await Isolate.spawn(
      CountDownTimer.runTimer,
      receivePort.sendPort,
    );
  }

  static void runTimer(SendPort sendPort) {
    int counter = AppConst.TIMER_MINUTES * 60;

    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      counter--;
      if (counter != 0) {
        sendPort.send(counter.toString());
      }
    });
  }

  static void stop() {
    if (isolate != null) {
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
