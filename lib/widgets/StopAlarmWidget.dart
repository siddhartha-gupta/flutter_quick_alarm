part of quick_alarm;

class StopAlarmWidget extends StatelessWidget {
  StopAlarmWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Icon(
              Icons.alarm_off,
              size: 100.0,
            ),
            onPressed: () {
              SchedulerService().stopAlarm();
            },
            color: Colors.white,
          ),
          new Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
          ),
          new Text(
            'Stop alarm',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 40.0,
            ),
          ),
        ],
      ),
    );
  }
}
