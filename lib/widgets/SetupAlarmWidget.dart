part of quick_alarm;

class SetupAlarmWidget extends StatefulWidget {
  @override
  SetupAlarmWidgetState createState() {
    return SetupAlarmWidgetState();
  }
}

class SetupAlarmWidgetState extends State<SetupAlarmWidget> {
  final _formKey = GlobalKey<FormState>();
  final _timerInputController =
      TextEditingController(text: AppConst.DEFAULT_TIMER_MINUTES.toString());

  @override
  void dispose() {
    _timerInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Form(
        key: _formKey,
        child: Expanded(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                width: 100,
                child: TextFormField(
                  controller: _timerInputController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 23,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  validator: (value) {
                    int val = int.tryParse(value);
                    if (val == null || val > 30 || val < 0) {
                      return 'Please enter a valid value';
                    }
                    return null;
                  },
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(
                  bottom: 5,
                ),
              ),
              new Text(
                'Time in minutes (between 1 to 30)',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15.0,
                ),
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
                  if (_formKey.currentState.validate()) {
                    int val = int.tryParse(_timerInputController.text);
                    SchedulerService().setupAlarm(val);
                  }
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
                  color: Colors.blueAccent,
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
