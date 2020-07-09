import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_challenge/src/signup.dart';
import '../utils/utility_class.dart';
import '../src/main_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginClass();
  }
}

class _LoginClass extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;

  Future<void> _submitCommand() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        showsnakbar(UtilityClass.noInternet);
      } else {
        _loginCommand();
      }
    }
  }

  Future<void> _loginCommand() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': _email, 'password': _password};
    var jsonResponse = null;
    String body = json.encode(data);
    var response = await post(UtilityClass.loginURL, headers: {"Content-Type": "application/json"},body: body);
      if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
       showsnakbar("Login Successfully");
       sharedPreferences.setString(UtilityClass.userName, jsonResponse['userName'].toString());
       sharedPreferences.setString(UtilityClass.token, jsonResponse['token'].toString());
       sharedPreferences.setString(UtilityClass.expires, jsonResponse['expires'].toString());
       Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
      }
    }else if(response.statusCode == 401){
      showsnakbar('Invalid Username and Password');
    } 
    else {
      showsnakbar('Something went worng');
    }
  }

  void showsnakbar(String string) {
    final snackbar = SnackBar(
      content: Text(string),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Hello',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('There',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  )
                ],
              ),
            ),
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      validator: (val) => !EmailValidator.validate(val, true)
                          ? 'Not a valid email.'
                          : null,
                      onSaved: (val) => _email = val,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      validator: (val) =>
                          val.length < 8 ? 'Password too short..' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    GestureDetector(
                      onTap: () {
                        _submitCommand();
                      },
                      child: Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New to App ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
