import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:gps_tracker/entitys/user_location.dart';
import 'package:gps_tracker/models/route.dart';
import 'package:gps_tracker/pages/routes_list.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracker/directions_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gps_tracker/db/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;
  
  @override
  _HomePageState createState() => _HomePageState(this.db);
}

class _HomePageState extends State<HomePage> {
  
  PolylinePoints polylinePoints = PolylinePoints();
  final Set<Polyline> polyline = {};
  late bool _serviceEnabled; //verificar o GPS (on/off)
  late PermissionStatus _permissionGranted; //verificar a permissão de acesso
  late String? address;
  late Timer _mytimer;
  late var result;
  late UserLocation userLocation;
  final AppDatabase db;
  LocationData? _userLocation;
  GoogleMapController? _googleMapController;
  Marker? _origin;
  bool? _isTracking = false;
  Marker? _destination;
  Directions? _info;
  // Entidade de rota para adicionar posteriormente
  late RouteEntity routeEntity;
  // final con = new RouteEntityController(this.db)
  _HomePageState(this.db);

  // Initial position of camera
  static CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  // Alterar a posição da camera
  CameraPosition _getCameraPosition(double latitude, double longitude) {
    return CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 11.5,
    );
  }

  // Inicializando o controller do mapa
  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }
  
  // Finalizar o controller do google map
  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  // Captura localização do user
  Future<void> _getUserLocation() async {
    Location location = Location();
    final _locationData = await location.getLocation();
    Future<List<Geocoding.Placemark>> places;
    double? lat;
    double? lng;

    //1. verificar se o serviço de localização está ativado
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    
    //2. solicitar a permissão para o app acessar a localização
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _userLocation = _locationData;
      lat = _userLocation!.latitude;
      lng = _userLocation!.longitude;
      _initialCameraPosition = CameraPosition(
        target: LatLng(lat!, lng!),
        zoom: 18,
      );

      places = Geocoding.placemarkFromCoordinates(lat!, lng!,
          localeIdentifier: "pt_BR");
      places.then((value) {
        Geocoding.Placemark place = value[1];
        address = place.street; //nome da rua
        print(_locationData.accuracy); //acurácia da localização
      });
    });
  }

  // Adiciona um marcador no mapa
  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: pos,
        );
      });
    }
  }

  void _startTracking() {

  setState(() {
    _isTracking = !_isTracking!;
  });
  }
  void _setCameraToActualLocation() { _googleMapController!.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        }
  void startServiceInAndroid() async {
    if (Platform.isAndroid) {
      var method = const MethodChannel("com.example.gps_tracker.messages");
      String data = await method.invokeMethod("startService");
      debugPrint(data);
    }
  }
  void stopServiceInAndroid() async {
    if (Platform.isAndroid) {
      var method = const MethodChannel("com.example.gps_tracker.messages");
      String data = await method.invokeMethod("stopService");
      debugPrint(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('GPS Tracker'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 29, 228, 36),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => {
                _googleMapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _destination!.position,
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                )
              },
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 75, 243, 33),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _userLocation?.latitude != null
                ? _getCameraPosition(_userLocation!.latitude as double,
                    _userLocation!.longitude as double)
                : _initialCameraPosition,
            onMapCreated:_onMapCreated,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null) //
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                  ElevatedButton(
                    onPressed: () async => {
                          
                          // Inicia a captura de localizações
                          _startTracking(),
                          if (_isTracking!) {
                            startServiceInAndroid(),
                            // muda a camera para o local atual
                            _setCameraToActualLocation(),
                            // inicia uma rota
                            
                            routeEntity = RouteEntity(
                                      null,
                                      'Rota',
                                       DateTime.now().toString()
                                    ),
                            await db.routeEntityDao.insertRouteEntity(routeEntity),
                          }else{
                            stopServiceInAndroid()
                          },
                          

                          // Timer a cada 5 segundos captura a localização
                          _mytimer = Timer.periodic(Duration(seconds: 5),
                              (timer) async {
                            if (_isTracking!) {
                              _getUserLocation();
                              if (_userLocation != null) {
                                
                               
                                List<RouteEntity> routeId = await db.routeEntityDao.findLastRouteEntity();
                                print('ROUTE ID');
                                // print(routeId.toString());
                                List<RouteEntity> list = routeId;
                                
                                var route_id  = list[0].id;
                                print(route_id);
                                userLocation = UserLocation(
                                    null,
                                    _userLocation!.latitude!,
                                    _userLocation!.longitude!,
                                    route_id!
                                    );
                                
                                await db.userLocationDao
                                    .insertUserLocation(userLocation);
                                result =
                                    db.userLocationDao.findUserLocationById(1);
                                print(result.toString());

                                () => _googleMapController!.animateCamera(
                                    _info != null
                                        ? CameraUpdate.newLatLngBounds(
                                            _info!.bounds, 100.0)
                                        : CameraUpdate.newCameraPosition(
                                            _initialCameraPosition));
                              }
                            }
                          })
                        },
                    child: Text(
                        _isTracking! ? 'Stop tracking' : 'Start tracking'
                      )
                    ),
                if (_userLocation != null)
                  SizedBox(
                    key: Key('lista-de-cordenadas'),
                    width: 380,
                    height: 600,
                    child: FutureBuilder<List<RouteEntity>>(
                      // future: db.userLocationDao.findAllUserLocation(),
                      // builder: (context, snapshot) {
                      //   return snapshot.hasData
                      //       ? ListView.builder(
                      //           itemCount: snapshot.data!.length,
                      //           itemBuilder: (context, index) {
                      //             // print(snapshot.data!.length);
                      //             // print(snapshot.data![index].latitude.toString());
                      //             return Text(snapshot.data![index].latitude
                      //                     .toString() +
                      //                     " " +
                      //                 snapshot.data![0].longitude.toString());
                      //           })
                      //       : Text('Sem dados');
                      // },
                      future: db.routeEntityDao.findLastRouteEntity(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  // print(snapshot.data!.length);
                                  // print(snapshot.data![index].latitude.toString());
                                  return Text(snapshot.data![index].id
                                          .toString() +
                                          " " +
                                      snapshot.data![0].name.toString());
                                })
                            : Text('Sem dados');
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("botaoIniciaRastreio"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        tooltip: 'Start',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RoutesList(db: db,)));
        },
        child: const Icon(Icons.add_location_alt_rounded),
      ),
    );
  } 
}
