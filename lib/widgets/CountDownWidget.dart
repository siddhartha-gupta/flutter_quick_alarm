part of quick_alarm;

class CountDownWidget extends StatefulWidget {
  CountDownWidget({Key key}) : super(key: key);

  @override
  CountDownWidgetState createState() => CountDownWidgetState();
}

class CountDownWidgetState extends State<CountDownWidget> {
  ReceivePort receivePort = ReceivePort();
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, AppConst.TIMER_PORT_NAME);
    receivePort.listen((data) {
      remainingTime = int.tryParse(data);
    });
  }

  @override
  void dispose() {
    receivePort.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Remaining: $remainingTime seconds',
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0,
      ),
    );
  }
}
