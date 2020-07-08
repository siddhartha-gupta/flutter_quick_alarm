part of quick_alarm;

class CountDownWidget extends StatefulWidget {
  CountDownWidget({Key key}) : super(key: key);

  @override
  CountDownWidgetState createState() => CountDownWidgetState();
}

class CountDownWidgetState extends State<CountDownWidget> {
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();

    CountDownTimer.receivePort.listen((data) {
      debugPrint('RECEIVE: ' + data + ', ');
      setState(() {
        remainingTime = int.tryParse(data);
      });
    });
  }

  @override
  void dispose() {
    CountDownTimer.receivePort.close();

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
