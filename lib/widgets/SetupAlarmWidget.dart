part of quick_alarm;

class SetupAlarmWidget extends StatelessWidget {
  SetupAlarmWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new RaisedButton(
            child: Icon(
              Icons.alarm,
              size: 100.0,
            ),
            onPressed: () {
              SchedulerService().setupAlarm();
            },
            color: Colors.white,
          ),
          new Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
          ),
          new Text(
            'Setup alarm',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 40.0,
            ),
          ),
        ],
      ),
    );
  }
}
