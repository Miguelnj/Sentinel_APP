import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/register/register_bloc.dart';
import 'package:flutterappfdp/src/blocs/register/register_events.dart';
import 'package:flutterappfdp/src/blocs/register/resgister_states.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  TextEditingController _repeatPasswordFieldController = TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _surnameFieldController = TextEditingController();

  RegisterBloc _registerBloc = RegisterBloc();

  @override
  void initState() {
    super.initState();
    _registerBloc.listen((state) {
      if (state is RegisterSuccessfulState)
        Navigator.pop(context, true);
    });
  }


  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: BlocBuilder(
        bloc: _registerBloc,
        builder: (context, state){
          if(state is RegisterInitial) return buildRegisterBody();
          else if(state is UsernameAlreadyExistsState){
            SchedulerBinding.instance.addPostFrameCallback((_) => showInputValidationError("The given username already exists"));
            return buildRegisterBody();
          }
          else if(state is RegisterLoadingState) return Status().buildLoadingView();
          return buildRegisterBody();
        }),
      );
  }

  Stack buildRegisterBody() {
    return Stack(
      children: <Widget>[
        buildBackgroundStyle(),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildRegisterLabel(),
                SizedBox(height: 15.0),
                buildMailTextField(),
                SizedBox(height: 15.0),
                buildPasswordField(),
                SizedBox(height: 15.0),
                buildRepeatPasswordField(),
                SizedBox(height: 15.0),
                buildNameField(),
                SizedBox(height: 15.0),
                buildSurnamesField(),
                SizedBox(height: 15.0),
                buildRegisterButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text buildRegisterLabel() {
    return Text(
      'Register',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildMailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: loginCommonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginCommonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _emailFieldController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email, color: Colors.white),
              hintText: 'mailaddress@dummy.com',
              hintStyle: registerCommonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: loginCommonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginCommonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _passwordFieldController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Enter your password',
              hintStyle: registerCommonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRepeatPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Repeat Password',
          style: loginCommonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginCommonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _repeatPasswordFieldController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Enter your password again',
              hintStyle: registerCommonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: loginCommonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginCommonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _nameFieldController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.person, color: Colors.white),
              hintText: 'Your name goes here!',
              hintStyle: registerCommonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSurnamesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Surnames',
          style: loginCommonLabelTextStyle(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginCommonBoxDecoration(),
          height: 60.0,
          child: TextField(
            controller: _surnameFieldController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.people, color: Colors.white),
              hintText: 'Your surname(s) goes here!',
              hintStyle: registerCommonHintTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration loginCommonBoxDecoration() {
    return BoxDecoration(
        color: Color(0xFF6CA8F1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 2))
        ]);
  }

  TextStyle loginCommonLabelTextStyle() {
    return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  }

  TextStyle registerCommonHintTextStyle() => TextStyle(color: Colors.white54);

  Widget buildRegisterButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 5.0,
            onPressed: () => signUpButtonPressed(),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.white,
            child: Text(
              'Register',
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 2.0,
                fontSize: 16.5,
              ),
            )));
  }

  Container buildBackgroundStyle() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
              stops: [
            0.1,
            0.4,
            0.7,
            0.9
          ])),
    );
  }

  signUpButtonPressed() {
    String name = _nameFieldController.text;
    String surname = _surnameFieldController.text;
    String username = _emailFieldController.text;
    String password = _passwordFieldController.text;
    if (!validateNotEmptyFields(name, surname, username, password)) {
      showInputValidationError("Fill the fields");
    } else if (_passwordFieldController.text !=
        _repeatPasswordFieldController.text) {
      showInputValidationError("Passwords does not match");
    } else if (!checkPasswordStructure(_passwordFieldController.text)) {
      showInputValidationError(
          "Password should contain a minimum of:\n1 Uppercase\n1 Lowercase\n1 Numeric Value\n8-15 characters");
    } else if (!validateEmail(_emailFieldController.text)) {
      showInputValidationError("Not a valid email");
    } else {
      _registerBloc.add(SignUpSubmitButtonPressed(
          name: name,
          surname: surname,
          username: username,
          password: password));
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateNotEmptyFields(name, surname, username, password) {
    return (name == "" || surname == "" || username == "" || password == "")
        ? false
        : true;
  }

  void showInputValidationError(text) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.red,
          );
        });
  }

}
bool checkPasswordStructure(password) {
  String pattern = r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(password);
}
