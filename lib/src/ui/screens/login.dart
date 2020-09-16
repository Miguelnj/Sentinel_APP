import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/auth/auth_bloc.dart';
import 'package:flutterappfdp/src/blocs/login/login_bloc.dart';
import 'package:flutterappfdp/src/blocs/login/login_events.dart';
import 'package:flutterappfdp/src/blocs/login/login_states.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc();
    _loginBloc = LoginBloc(_authenticationBloc);
    _loginBloc.listen((state) {
      if (state is LoginSucceed)
        Navigator.pushReplacementNamed(context, '/events/list');
    });
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.close();
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: BlocBuilder(
        bloc: _loginBloc,
        builder: (context, state){
          if(state is LoginInitial) return buildLoginBody();
          else if(state is LoginLoading) return Status().buildLoadingView();
          else if(state is LoginFailure){
            SchedulerBinding.instance.addPostFrameCallback((_) => showFailureResponse(state.error));
            return buildLoginBody();
          }
          else return buildLoginBody();
        },
      ),
    );
  }

  Stack buildLoginBody() {
    return Stack(
      children: <Widget>[
        buildBackgroundStyle(),
        Container(
            height: double.infinity,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding:
                EdgeInsets.symmetric(horizontal: 40.0, vertical: 160.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildSignInLabel(),
                    SizedBox(height: 30.0),
                    buildMailTextField(),
                    SizedBox(height: 30.0),
                    buildPasswordField(),
                    buildLoginButton(),
                    buildSignUpButton(),
                  ],
                )))
      ],
    );
  }

  Text buildSignInLabel() {
    return Text(
      'Sign in',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
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
              hintStyle: loginCommonHintTextStyle(),
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
              hintStyle: loginCommonHintTextStyle(),
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

  GestureDetector buildSignUpButton() {
    return GestureDetector(
      onTap: () async{
        var isSuccessful = await Navigator.of(context).pushNamed('/register');
        if(isSuccessful == true) showSuccessfulRegister();
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'Don\'t have an account yet?  ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400),
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }

  TextStyle loginCommonHintTextStyle() => TextStyle(color: Colors.white54);

  Widget buildLoginButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 5.0,
            onPressed: () {
              _loginBloc.add(LoginButtonPressed(
                username: _emailFieldController.text,
                password: _passwordFieldController.text,
              ));
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.white,
            child: Text(
              'LOGIN',
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 2.0,
                fontSize: 16.5,
              ),
            )));
  }

  void showFailureResponse(text) {
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

  void showSuccessfulRegister() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              "You were registered successfully!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.green,
          );
        });
  }

}
