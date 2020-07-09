import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utility_class.dart';
import '../src/main_screen.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
      _singupCommand();
      }
    }
  }

  Future<void> _singupCommand() async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': _email, 'password': _password};
    final data1 = jsonEncode({
      "username": _email,
      "password": _password
    });
    var jsonResponse = null;
    String body = json.encode(data);
  var response = await post(UtilityClass.server, headers: {"Content-Type": "application/json"},body: data1);
    print(data1.toString());
      if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
       showsnakbar("Register Successfully");
       sharedPreferences.setString(UtilityClass.userName, jsonResponse['userName'].toString());
       sharedPreferences.setString(UtilityClass.token, jsonResponse['token'].toString());
       sharedPreferences.setString(UtilityClass.expires, jsonResponse['expires'].toString());
       Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
      }
    } else {
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
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        key: scaffoldKey,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
             Form(
              key: formKey,
              child:  Container(
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
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'PASSWORD ',
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
                      SizedBox(height: 50.0),
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
                                  'SIGNUP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text('Go Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  ,),),
            ]));
  }
}
