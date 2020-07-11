part of quick_alarm;

class AlarmInPlaceWidget extends StatelessWidget {
  AlarmInPlaceWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int timer = StorageService.getInteger('currentTimerMinutes');

    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Alarm placed for $timer mins',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 25.0,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
          ),
          CountDownWidget(),
          new Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
          ),
          new RaisedButton(
            child: Icon(
              Icons.cancel,
              size: 100.0,
            ),
            onPressed: () {
              SchedulerService().cancelAlarm();
            },
            color: Colors.white,
          ),
          new Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
          ),
          new Text(
            'Cancel alarm',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
