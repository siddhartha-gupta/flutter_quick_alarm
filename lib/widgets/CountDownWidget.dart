part of quick_alarm;

class CountDownWidget extends StatefulWidget {
  CountDownWidget({Key key}) : super(key: key);

  @override
  CountDownWidgetState createState() => CountDownWidgetState();
}

class CountDownWidgetState extends State<CountDownWidget> {
  Timer _timer;
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();

    runTimer();
  }

  runTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        int diff = (StorageService.getInteger('timestamp') -
            DateTime.now().millisecondsSinceEpoch);
        diff = diff ~/ 1000;

        if (diff == 1) {
          print('cancelling timer');
          _timer.cancel();
        }
        setState(() {
          remainingTime = diff;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Remaining: $remainingTime seconds',
      style: TextStyle(
        color: Colors.amber[900],
        fontSize: 25.0,
      ),
    );
  }
}
