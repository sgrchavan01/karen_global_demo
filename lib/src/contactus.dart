import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactUsState();
  }
}

class _ContactUsState extends State<ContactUs> {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(51.514870, -0.123649), zoom: 18);
  GoogleMapController mapController;
  Set<Marker> markers;

  Set<Marker> _createMarker() {
    var marker = Set<Marker>();

    marker.add(Marker(
      markerId: MarkerId("MarkerCurrent"),
      position: LatLng(51.514870, -0.123649),
      infoWindow: InfoWindow(
        title: "Karken Global",
        snippet: "71-75 Shelton Street Covent Garden London WC2H 9JQ",
      ),
      draggable: false,
    ));

    return marker;
  }

  void backToScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        backToScreen(context);
      },
      child: Scaffold(
           backgroundColor:Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor:Color(0xffe8e8e8),
          title: new Text(
            "",
            style: new TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              backToScreen(context);
            },
          ),
        ),
        body:
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('Contact Us',style: TextStyle( fontSize:25, fontWeight: FontWeight.bold,color: Colors.black),),
            ),

            Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('Get help and support,troubleshoot your service or get in touch with us.',style: TextStyle( fontSize:16, color: Colors.grey),),
            ),

            Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('Email',style: TextStyle( fontSize:14, color: Colors.grey),),
            ),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('contact@kraken.global',style: TextStyle( fontSize:14, color: Colors.black),),
            ),

            Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('Telephone',style: TextStyle( fontSize:14, color: Colors.grey),),
            ),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('+44 (0) 2080 888886',style: TextStyle( fontSize:14, color: Colors.black),),
            ),

            Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('Website',style: TextStyle( fontSize:14, color: Colors.grey),),
            ),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('www.kraken.global',style: TextStyle( fontSize:14, color: Colors.black),),
            ),


             Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('Address',style: TextStyle( fontSize:14, color: Colors.grey),),
            ),
            Container(
              margin: EdgeInsets.only(left:20.0),
              child:  Text('71-75 Shelton Street Covent Garden London WC2H 9JQ',style: TextStyle( fontSize:14, color: Colors.black),),
            ),
           
             Container(margin: EdgeInsets.only(top:20.0),),
            Container(
              height: 200.0,
              margin: EdgeInsets.all(10.0),
              child: GoogleMap(
                markers: _createMarker(),
                initialCameraPosition: _initialLocation,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
