


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  LatLng _initialPosition = LatLng(47.824366, -122.182920);
  GoogleMapController _controller;
  Location _location = Location();
  List<Marker> myMarker = [];
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor currentL;
  Marker currentMarker;
  bool dialVisible = true;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0),
        'assets/images/Trash.png').then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  void _onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;


    setState(() {
      currentMarker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );

      myMarker.add(currentMarker);
    });
    /*
    _location.onLocationChanged.listen((l){
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
            zoom: 14
          ),
        ),
      );
    });

     */
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Pranav'),
              accountEmail: Text('name@email.com'),

              currentAccountPicture: CircleAvatar(
                child: Text('P'),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_searching),
              title: Text('Distance From User'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('Severity (Low To High)'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('Severity (High To Low)'),
              onTap: () {},
            ),

          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Location'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapToolbarEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(47.824366, -122.182920),
          zoom: 14,
        ),
        markers: Set.from(myMarker),
        onTap: _handleTap,
      ),

      floatingActionButton: SpeedDial(
        marginRight: 175,
        //marginBottom: 40,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: dialVisible,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.clear),
              backgroundColor: Colors.red,
              label: 'Clear All',
              //labelStyle: TextTheme(fontSize: 18.0),
              onTap: () {
                setState(() {
                  myMarker.removeRange(0, myMarker.length);
                  print(myMarker.length);
                  myMarker.add(currentMarker);
                });
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.check_circle),
            backgroundColor: Colors.blue,
            label: 'Confirm Last Marker',
            //labelStyle: TextTheme(fontSize: 18.0),
            onTap: () {
              confirmLastMarker();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.location_searching),
            backgroundColor: Colors.green,
            label: 'Relocate',
            //labelStyle: TextTheme(fontSize: 18.0),
            onTap: () {
              updateCamera();
            },
          ),
        ],
      ),

      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateCamera();
        },
        child: Icon(Icons.location_searching),
      ),


       */
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,

    );
  }

  void updateCamera(){
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
            zoom: 14
        ),
      ),
    );
  }

  void _handleTap(LatLng tappedPoint) {
    print(tappedPoint);

    setState(() {
      //myMarker = [];
      myMarker.add(
          Marker(
            markerId: MarkerId(myMarker.length.toString()),
            position: tappedPoint,
            icon: pinLocationIcon,
            draggable: true,
            infoWindow: InfoWindow(
              title: 'Confirmed: NO'
            ),
          )
      );


    });
  }


  void confirmLastMarker() {
      setState(() {
        if(myMarker.length > 1) {
          LatLng point = myMarker[myMarker.length-1].position;
          myMarker.removeAt(myMarker.length-1);
          myMarker.add(
              Marker(
                markerId: MarkerId(myMarker.length.toString()),
                position: point,
                icon: pinLocationIcon,
                draggable: true,
                infoWindow: InfoWindow(
                    title: 'Confirmed: YES'
                ),
              ),
          );
          print('yay');
        }
      });
  }

  /*
  confirmMarker(int index, LatLng tappedPoint){
    myMarker.removeAt(index);
    myMarker.add(
        Marker(
          markerId: MarkerId(myMarker.length.toString()),
          position: tapped,
          icon: pinLocationIcon,
          draggable: true,
          infoWindow: InfoWindow(
            title: "Confirm",
            onTap: confirmMarker(myMarker.length + 1, tappedPoint.toString()),
          ),
        )

  }

   */
}





