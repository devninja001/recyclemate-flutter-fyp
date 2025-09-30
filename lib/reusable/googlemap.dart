import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as plc;
import 'package:url_launcher/url_launcher.dart';

class Gmap extends StatefulWidget {
  final List<plc.PlacesSearchResult> nearbyPlaces;

  const Gmap({super.key, required this.nearbyPlaces});

  @override
  State<Gmap> createState() => GmapState(nearbyPlaces: nearbyPlaces);
}

Set<Marker> markers = {};

class GmapState extends State<Gmap> {
  final List<plc.PlacesSearchResult> nearbyPlaces;

  GmapState({required this.nearbyPlaces});
  static GmapState? gmapState;

  static const kGoogleApiKey = 'AIzaSyDV8_kYoCxFkfIuO-DUGt9istH68HxOZas';

  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(2.999541, 101.7030556), zoom: 13);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: _buildMarkers(),
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) async {
            googleMapController = controller;
            GmapState.gmapState = this;

            Position position = await _determinePosition();

            googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 13)));

            markers.clear();

            markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude),
              ),
            );
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    return nearbyPlaces.map((place) {
      return Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(
          place.geometry!.location.lat,
          place.geometry!.location.lng,
        ),
        // You can customize the marker as needed
        // For example, add an info window with the place name
        infoWindow: InfoWindow(
          title: place.name,
          snippet: "${place.vicinity}\n${place.rating.toString()} ",
          onTap: () {
            openMap(place.name);
          },
        ),
      );
    }).toSet();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return Future.error('Location services are disabled');
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return Future.error('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permission permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition();

      return position;
    } catch (e) {
      Position position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true);
      return position;
    }
  }

  Future<LatLng> getCurrentLatLng() async {
    Position position = await _determinePosition();
    return LatLng(position.latitude, position.longitude);
  }

  static Future<void> openMap(String placeName) async {
    Uri googleMapURL =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$placeName");

    if (await canLaunchUrl(googleMapURL)) {
      await launchUrl(googleMapURL);
    } else {
      throw 'Could not open Google Maps';
    }
  }
}
