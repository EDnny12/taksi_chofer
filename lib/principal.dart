import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taksi_chofer/state/app_state.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<AppState>(context).scaffoldKey,
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return appState.initialPosition == null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitPouringHourglass(
                      color: Colors.black,
                      size: 50.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text(
                    "Por favor active el gps",
                    style: TextStyle(color: Colors.amber, fontSize: 18.0),
                  ),
                )
              ],
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: appState.initialPosition, zoom: 17.0),
                onMapCreated: appState.onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal, //normal
                compassEnabled: true,
                rotateGesturesEnabled: false,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                onLongPress: (LatLng) {
                  appState.getDestinationLongPress(LatLng, context);
                },
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 60.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 3)
                      ]),
                  child: TextField(
                    onTap: () async {},
                    cursorColor: Colors.blue.shade900,
                    controller: appState.destinationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20.0, top: 5.0),
                        width: 10.0,
                        height: 10,
                        child: Icon(
                          Icons.local_taxi,
                        ),
                      ),
                      hintText: "Destino",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
