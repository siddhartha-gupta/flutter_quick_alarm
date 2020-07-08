part of quick_alarm;

class CountDownWidget extends StatefulWidget {
  CountDownWidget({Key key}) : super(key: key);

  @override
  CountDownWidgetState createState() => CountDownWidgetState();
}

class CountDownWidgetState extends State<CountDownWidget> {
  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, AppConst.TIMER_PORT_NAME);
    receivePort.listen((v) {
      Scheduler().buzzAlarm();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Alarm placed for ${AppConst.TIMER_MINUTES} mins',
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0,
      ),
    );
  }
}
