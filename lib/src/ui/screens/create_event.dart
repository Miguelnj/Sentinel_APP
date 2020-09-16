import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/createEvent/create_event_bloc.dart';
import 'package:flutterappfdp/src/blocs/createEvent/create_event_events.dart';
import 'package:flutterappfdp/src/blocs/createEvent/create_event_states.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _locationFieldController = TextEditingController();

  CreateEventBloc _createEventBloc = CreateEventBloc();

  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: BlocBuilder(
          bloc: _createEventBloc,
          builder: (context, state) {
            if (state is LoadingState)
              return Status().buildLoadingView();
            else if (state is EventCreationSuccessful) {
              SchedulerBinding.instance
                  .addPostFrameCallback((_) => showFloattingMessage("Event Created Successfully"));
              return buildCreateEventBody();
            } else if (state is EventCreationUnsuccessful) {
              SchedulerBinding.instance.addPostFrameCallback((_) =>
                  showFloattingMessage("Oops!! There was a problem while creating the event", isSuccess: false));
              return buildCreateEventBody();
            }
            return buildCreateEventBody();
          }),
    );
  }

  Container buildCreateEventBody() {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildCreateEventLabel(),
            SizedBox(height: 15.0),
            buildNameTextField(),
            SizedBox(height: 15.0),
            buildLocationTextField(),
            SizedBox(height: 15.0),
            buildSelectStartDate(),
            SizedBox(height: 15.0),
            buildSelectEndDate(),
            SizedBox(height: 15.0),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Text buildCreateEventLabel() {
    return Text(
      'Create Event',
      style: TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: commonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: commonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _nameFieldController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.text_fields, color: Colors.black),
              hintText: 'Math classes',
              hintStyle: commonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLocationTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Location',
          style: commonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: commonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _locationFieldController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.location_on, color: Colors.black),
              hintText: 'School',
              hintStyle: commonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  buildSelectStartDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Start Date',
          style: commonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: commonBoxDecoration(),
          child: ListTile(
            title: buildPickDateTitle(_startDate),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: () {
              _pickDate(_startDate).then((pickedDate) {
                setState(() => _startDate = pickedDate);
              });
            },
          ),
        )
      ],
    );
  }

  buildSelectEndDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'End Date',
          style: commonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: commonBoxDecoration(),
          child: ListTile(
            title: buildPickDateTitle(_endDate),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: () {
              _pickDate(_endDate).then((pickedDate) {
                setState(() => _endDate = pickedDate);
              });
            },
          ),
        ),
      ],
    );
  }

  BoxDecoration commonBoxDecoration() {
    return BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 2))]);
  }

  TextStyle commonLabelTextStyle() {
    return TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  }

  TextStyle commonHintTextStyle() => TextStyle(color: Colors.grey[500]);

  Future<DateTime> _pickDate(DateTime currentDateTime) async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      TimeOfDay time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    if (currentDateTime != null)
      return currentDateTime;
    else
      return null;
  }

  buildPickDateTitle(DateTime date) {
    if (date == null)
      return Text("Tap to pick a date");
    else
      return Text(
        DateFormat.yMMMMEEEEd().add_jm().format(date),
        style: TextStyle(fontSize: 15),
      );
  }

  MaterialButton buildSubmitButton() {
    return MaterialButton(
      color: Colors.blue[900],
      onPressed: () => submitCreateEvent(),
      child: Text(
        "Create event",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void showFloattingMessage(text, {bool isSuccess = true}) {
    showDialog(
        context: context,
        builder: (context) {
          if(isSuccess) setTimerToPop();
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: isSuccess == true ? Colors.green : Colors.red,
          );
        });
  }

  submitCreateEvent() {
    if (!validateNotEmptyFields())
      showFloattingMessage("All fields are required", isSuccess: false);
    else if(!datesAreValid()) showFloattingMessage("End date should be later than start date", isSuccess: false);
    else {
      _createEventBloc.add(EventCreationSubmittedEvent(
        name: _nameFieldController.text,
        location: _locationFieldController.text,
        startDate: _startDate,
        endDate: _endDate,
      ));
    }
  }

  bool validateNotEmptyFields() {
    return (_nameFieldController.text == "" ||
            _locationFieldController.text == "" ||
            _startDate == null ||
            _endDate == null)
        ? false
        : true;
  }

  bool datesAreValid() {
    return _endDate.compareTo(_startDate) == 1 ? true : false;
  }

  void setTimerToPop() {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop(true);
    });
  }
}
