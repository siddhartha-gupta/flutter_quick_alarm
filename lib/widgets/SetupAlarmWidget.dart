part of quick_alarm;

class SetupAlarmWidget extends StatefulWidget {
  @override
  SetupAlarmWidgetState createState() {
    return SetupAlarmWidgetState();
  }
}

class SetupAlarmWidgetState extends State<SetupAlarmWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Form(
        key: _formKey,
        child: Expanded(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: TextStyle(
                  fontSize: 20.0,
                  height: 1.0,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Time in minutes (between 1 to 30)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                validator: (value) {
                  int val = int.tryParse(value);
                  if (val == null || val > 30 || val < 0) {
                    return 'Please enter value';
                  }
                  return null;
                },
              ),
              new Padding(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
              ),
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
        ),
      ),
    );
  }
}
