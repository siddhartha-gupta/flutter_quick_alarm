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

    runTimer();
  }

  runTimer() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        int diff = (StorageService.getInteger('timestamp') -
            DateTime.now().millisecondsSinceEpoch);
        diff = diff ~/ 1000;

        if (diff == 1) {
          print('cancelling timer');
          timer.cancel();
        }
        setState(() {
          remainingTime = diff;
        });
      },
    );
  }

  @override
  void dispose() {
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
