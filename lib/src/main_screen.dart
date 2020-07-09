import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_challenge/utils/utility_class.dart';
import '../src/login.dart';
import '../model/HumanVitalsModel.dart';
import '../src/contactus.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPage();
  }
}

showLogoutDailog(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancel",
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Ok",
    ),
    onPressed: () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Logout",
    ),
    content: Text(
      "Are you sure want to logout?",
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _MainPage extends State<MainPage> {
  final formKey = GlobalKey<FormState>();
  String username = "";
  bool _isLoading = false;
  String _heartRate;
  String _temperature;
  String _deviceId;
  List<HumanVitalsModel> humanViralModel = [];

  Future<Null> gethumanVitalList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url =
        UtilityClass.humanVitalList + "/" + UtilityClass.organizationId;
    String token = prefs.getString(UtilityClass.token);
    print(url + "," + token);
    final response = await get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    final responseJson = json.decode(response.body)['humanVitals'];

    setState(() {
      for (Map user in responseJson) {
        humanViralModel.add(HumanVitalsModel.fromJson(user));
      }
      _isLoading = false;
    });
  }

  Future<void> uploadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = UtilityClass.humanVitalList;
    String token = prefs.getString(UtilityClass.token);
    final data = jsonEncode({
      "organizationId": UtilityClass.organizationId,
      "businessUnitId": UtilityClass.businessUnitId,
      "deviceId": _deviceId,
      "heartRate": int.parse(_heartRate),
      "temperature": double.parse(_temperature)
    });
    var response = await post(url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: data);
    print(url + "," + token + "," + data.toString());
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = true;
        gethumanVitalList();
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getUserDetails();
    gethumanVitalList();
  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Details'),
            content: Container(
              height: 200.0,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Heart Rate',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      validator: (val) =>
                          val.isEmpty ? 'Please Enter Heart Beats.' : null,
                      onSaved: (val) => _heartRate = val,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Body Temperature',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      validator: (val1) => val1.isEmpty
                          ? 'Please Enter Body Temperature '
                          : null,
                      onSaved: (val1) => _temperature = val1,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () async {
                  _deviceId = await _getId();
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    uploadDetails();
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0xff323232),
                title: Text(
                  "KARKEN GLOBAL",
                )),
            drawer: new Drawer(
              child: Container(
                color: Colors.black45,
                child: new ListView(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xff323232),
                      ),
                      accountName: new Text(
                        username,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            ExactAssetImage('assets/images/app_logo.png'),
                        backgroundColor: Colors.white,
                      ),
                      accountEmail: new Text(
                        '',
                      ),
                    ),
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage('assets/images/home.png'),
                          color: Colors.white,
                        ),
                        title: new Text(
                          "Home",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        }),
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage('assets/images/contact.png'),
                          color: Colors.white,
                        ),
                        title: new Text(
                          "Contact Us",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactUs()),
                          );
                        }),
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage('assets/images/logout.png'),
                          color: Colors.white,
                        ),
                        title: new Text(
                          "Logout",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showLogoutDailog(context);
                        }),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(Icons.add),
              onPressed: () {
                _displayDialog(context);
              },
            ),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: humanViralModel == null
                            ? 0
                            : humanViralModel.length,
                  
                        itemBuilder: (BuildContext ctxt, int index) {
                          //return listItems(index);
                          return GestureDetector(
                            child: listItems(index),
                            onTap: () {},
                          );
                        }))));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString(UtilityClass.userName);
    });
  }

  Widget listItems(int index) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 5.0),
      child: Card(
        elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
           'User Name $index',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.0,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
            maxLines: 10,
          ),
         Container(margin: EdgeInsets.all(5.0),),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(children: <Widget>[
                   SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child:  Image.asset('assets/images/heart.png'),
                  ),
                  // ImageIcon(AssetImage('assets/images/heart.png'),
                  //    size: 16.0),
                  Flexible(
                      child: Text(
                    " " + humanViralModel[index].heartRate.toString() +" Beats",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                  )),
                ]),
              ),
              Expanded(
                child: Row(children: <Widget>[
                   SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child:  Image.asset('assets/images/thermometer.png'),
                  ),
                  // ImageIcon(AssetImage('assets/images/thermometer.png'),
                  //     size: 16.0),
                  Flexible(
                      child: Text(
                          " " + humanViralModel[index].temperature.toStringAsFixed(2).toString()+" F",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 3)),
                ]),
              ),
            ],
          ),
      Container(margin: EdgeInsets.all(5.0),),
           Row(
            children: <Widget>[
              Expanded(
                child: Row(children: <Widget>[
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child:  Image.asset('assets/images/time.png'),
                  ),
                  Flexible(
                      child: Text(
                    " " + humanViralModel[index].timestamp.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                  )),
                ]),
             
                   ),
            ],
          ),
        ],
      ),
      ),
      ),
    );
  }
}
