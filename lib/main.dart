import 'dart:async';
import 'location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'maps para trenes',
      home: MapSample(),
    );
  }
}

Future _getCurrentLocation() async {
  LocationPermission permission;
  permission = await Geolocator.requestPermission();
  List geolocacion = [];
  final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print(position);
  return geolocacion = [
    position.latitude,
    position.longitude,
  ];
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _searchController = TextEditingController();

  static final Marker _adifMarker = Marker(
    markerId: MarkerId('_adifMarker'),
    infoWindow: InfoWindow(title: "ADIF"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(-34.592416, -58.375432),
  );
  //
  // static final Marker _adifMarker2 = Marker(
  //   markerId: MarkerId('_adifMarker2'),
  //   infoWindow: InfoWindow(title: "ADIF"),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(_getCurrentLocation()),
  // );

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-34.599560, -58.403238),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('google maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      const InputDecoration(hintText: "busque una ciudad"),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_searchController.text);
                  _goToPlace(place);
                },
                icon: const Icon(Icons.add_location),
              ),
              const ElevatedButton(
                // style: style,
                onPressed: _getCurrentLocation,
                child: Text('donde estoy?'),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              markers: {_adifMarker},
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goTowork,
        label: Text('al trabajo!'),
        icon: Icon(Icons.account_balance_rounded),
      ),

      //   floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goTowork,
      //   label: Text('al trabajo!'),
      //   alignment: Alignment.bottomLeft,
      //   icon: Icon(Icons.account_balance_rounded),
      // ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12,
    )));
  }

  Future<void> _goTowork() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 10.8334901395799,
        target: LatLng(-34.592416, -58.375432),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }
}
