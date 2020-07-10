part of quick_alarm;

class AlarmInPlaceWidget extends StatelessWidget {
  AlarmInPlaceWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Alarm placed for ${AppConst.TIMER_MINUTES} mins',
            style: TextStyle(
              color: Colors.amber,
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
        ],
      ),
    );
  }
}
