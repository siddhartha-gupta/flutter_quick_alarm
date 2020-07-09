part of quick_alarm;

class CountDownService {
  static Isolate isolate;
  static ReceivePort receivePort;

  static void start() async {
    CountDownService.receivePort = ReceivePort();
    CountDownService.isolate = await Isolate.spawn(
      CountDownService.runTimer,
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
