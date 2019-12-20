import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:location/location.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition, destination;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  String ciudadUsuario, codigo_postal, codigo_postal2;
  BitmapDescriptor pinLocationIcon;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  //GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  //GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //firebase
  final databaseReference = Firestore.instance;
  Geoflutterfire geofire = Geoflutterfire();
  Geolocator geolocator = Geolocator();

  //Location location;

  AppState() {
    //location = new Location();
    setCustomMapPin();
    _getUserLocation();
    _loadingInitialPosition();
    obtenerUbicacion();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/marker_car.png');
  }

  //obtener la ubicacion del usuario
  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    _initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    ciudadUsuario = placemark[0].locality; // comitan de dominguez
    codigo_postal2 = placemark[0].administrativeArea; // chiapas
    print("cuidad $ciudadUsuario");
    //locationController.text = placemark[0].thoroughfare + "-" + placemark[0].name + "," + placemark[0].subLocality;
    obtenerUbicacion();
    notifyListeners();
  }

  void obtenerUbicacion(){
    /*location.onLocationChanged().listen((LocationData cLoc) {
      _initialPosition = LatLng(cLoc.latitude, cLoc.longitude);
      print('ubicacion ' + cLoc.latitude.toString() +' '+ cLoc.longitude.toString());
      updateUbicacionTaxi(cLoc.latitude, cLoc.longitude);
      addMarker(_initialPosition, "");
      centrarCamara(_initialPosition);
    });*/

    geolocator
        .getPositionStream(LocationOptions(
        accuracy: LocationAccuracy.high, timeInterval: 2000))
        .listen((position) {
      _initialPosition = LatLng(position.latitude, position.longitude);
      updateUbicacionTaxi(position.latitude, position.longitude);
      print('ubicacion ' + position.latitude.toString() + ' ' + position.longitude.toString());
      addMarker(_initialPosition, "");
      centrarCamara(_initialPosition);
    });

  }

  //agregar destino presionando en el mapa
  void getDestinationLongPress(LatLng coordenadas, context) async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(coordenadas.latitude, coordenadas.longitude);
    destinationController.text = placemark[0].thoroughfare +
        "-" +
        placemark[0].name +
        "," +
        placemark[0].subLocality;

    destination = LatLng(coordenadas.latitude, coordenadas.longitude);
    addMarker(destination, "destino");
    //mover la camara
    centrarCamara(coordenadas);
    notifyListeners();
  }

  //Agregar un marcador en el mapa
  void addMarker(LatLng location, String address) {
    _markers.clear();
    _markers.add(Marker(
        markerId: MarkerId("destino"),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: pinLocationIcon));
    notifyListeners();
  }


  void centrarCamara(LatLng coordenadas){
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(coordenadas.latitude, coordenadas.longitude),
          zoom: 18.0)),
    );
  }


  //movimiento de la camara
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    showSnackBar('Estas en linea!');
    //changeMapMode();
    notifyListeners();
  }

  //loader de ubicacion inicial
  void _loadingInitialPosition() async {
    //GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus(); ejemplo para checar si los permisos estan habilitados
    //if(_initialPosition == null){
    await Future.delayed(Duration(seconds: 7)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
    //}
  }

  showSnackBar(String texto) {
    final snackBar = SnackBar(
      content: Text(texto),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void updateUbicacionTaxi(double latitud, double longitud) async {
    await databaseReference
        .collection(ciudadUsuario)
        .document('victor')
        .setData({
      'latitud': latitud.toString(),
      'longitud': longitud.toString(),
    });
  }
}
