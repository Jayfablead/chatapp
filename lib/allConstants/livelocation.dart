import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class location extends StatefulWidget {
  final loc;

  location({this.loc});

  @override
  _locationState createState() => _locationState();
}

class _locationState extends State<location> {
  BitmapDescriptor? icon;
  ScrollController _scrollController = ScrollController();

  Geolocator geolocator = Geolocator();
  Completer<GoogleMapController> _controller = Completer();

  String? msg;

  GeoPoint? geoPoint;

  // on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // void getLocation() async{
  //   // await FirebaseFirestore.instance.collection("Location").doc("5hGxSAVPSPwgIMcNGRxM").get().then((document) async{
  //   //   var icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 3.2),"img/img11.png");
  //   //   setState(() {
  //   //     this.icon = icon;
  //   //   });
  //   //   setState(() {
  //   //     _markers.add(Marker(markerId: MarkerId('Home'),
  //   //         icon: icon,
  //   //         position: LatLng(double.parse(document["lattitude"]),double.parse(document["longtitude"]))
  //   //     ));
  //   //   });
  //   // });
  //
  //   var icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 3.2),"img/img11.png");
  //   setState(() {
  //     this.icon = icon;
  //   });
  //   // var location = await currentLocation.getLocation();
  //   currentLocation?.onLocationChanged.listen((LocationData loc){
  //     _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //       target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
  //       zoom: 12.0,
  //     )));
  //     print(loc.latitude);
  //     print(loc.longitude);
  //     setState(() {
  //      _markers.add(Marker(markerId: MarkerId('Home'),
  //           icon: icon,
  //           position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
  //       ));
  //      _markers.add(Marker(markerId: MarkerId('Adajan'),
  //          icon: icon,
  //          position: LatLng(21.1959,72.7933)
  //      ));
  //      _markers.add(Marker(markerId: MarkerId('Rander'),
  //          icon: icon,
  //          position: LatLng(21.2189,72.7961)
  //      ));
  //     });
  //   });
  // }
  Timer? timer;

// getLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best)
  //         .timeout(const Duration(seconds: 5));
  //     return position;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // final CameraPosition _myLocation = CameraPosition(target: LatLng(position.latitude, position!.longitude), zoom: 9);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          // on below line setting camera position
          initialCameraPosition: _kGoogle,
          // on below line we are setting markers on the map
          markers: Set<Marker>.of(_markers),
          // on below line specifying map type.
          mapType: MapType.normal,
          // on below line setting user location enabled.
          myLocationEnabled: true,
          // on below line setting compass enabled.
          compassEnabled: true,
          // on below line specifying controller on map complete.
          onMapCreated: (GoogleMapController controller) {
            // getUserCurrentLocation().then(
            //       (value1) async {
            //     setState(() {
            //       msg = value1.toString();
            //       print('msg==============' + msg.toString());
            //     });
            //     _markers.add(Marker(
            //       markerId: MarkerId("2"),
            //       position: LatLng(value1.latitude, value1.longitude),
            //       infoWindow: InfoWindow(
            //         title: 'My Current Location',
            //       ),
            //     ));
            //     setState(() {
            //       geoPoint = new GeoPoint(value1.latitude, value1.longitude);
            //     });
            //
            //     // specified current users location
            //     CameraPosition cameraPosition = new CameraPosition(
            //       target: LatLng(value1.latitude, value1.longitude),
            //       zoom: 14,
            //     );
            //     print(value1.latitude.toString() +
            //         " " +
            //         value1.longitude.toString());
            //     final GoogleMapController controller = await _controller.future;
            //     controller.animateCamera(
            //         CameraUpdate.newCameraPosition(cameraPosition));
            //   },
            // );
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            getUserCurrentLocation().then(
              (value1) async {
                setState(() {
                  msg = value1.toString();
                  print('msg==============' + msg.toString());
                });
                _markers.add(Marker(
                  markerId: MarkerId("2"),
                  position: LatLng(value1.latitude, value1.longitude),
                  infoWindow: InfoWindow(
                    title: 'My Current Location',
                  ),
                ));
                setState(() {
                  geoPoint = new GeoPoint(value1.latitude, value1.longitude);
                });

                // specified current users location
                CameraPosition cameraPosition = new CameraPosition(
                  target: LatLng(value1.latitude, value1.longitude),
                  zoom: 14,
                );
                print(value1.latitude.toString() +
                    " " +
                    value1.longitude.toString());
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));
              },
            );
            DateTime date = DateTime.now();
            print(date);
            String formattedDate = DateFormat('dd-MM-yy').format(date);
            String formattedDate1 =
                DateFormat().add_jm().format(DateTime.now());
            SharedPreferences pref = await SharedPreferences.getInstance();
            var senderid = pref.getString("senderid");
            var receiverid = widget.loc;
            FirebaseFirestore.instance
                .collection("user")
                .doc(senderid)
                .collection("chat")
                .doc(receiverid)
                .collection("message")
                .add({
              "senderid": senderid,
              "receiverid": receiverid,
              "massages": geoPoint,
              "type": "location",
              "date": formattedDate.toString(),
              "time": date.toString(),
              "timestrap": formattedDate1.toString(),
            }).then((value) async {
              await FirebaseFirestore.instance
                  .collection("user")
                  .doc(receiverid)
                  .collection("chat")
                  .doc(senderid)
                  .collection("message")
                  .add({
                "senderid": senderid,
                "receiverid": receiverid,
                "massages": geoPoint,
                "type": "location",
                "date": formattedDate.toString(),
                "time": date.toString(),
                "timestrap": formattedDate1.toString(),
              }).then((value) {
                print(value);

                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut);
              });

              // marker added for current users location
            });

            Navigator.of(context).pop();
          },
          label: Row(
            children: [
              Text("Share your Live location"),
              Icon(Icons.location_searching)
            ],
          ),
        ));
  }
}
