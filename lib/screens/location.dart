// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fyp/reusable/googlemap.dart';
import 'package:fyp/screens/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as plc;

class LocationScreen extends StatefulWidget {
  final List<plc.PlacesSearchResult> nearbyPlaces;

  const LocationScreen({super.key, required this.nearbyPlaces});

  @override
  State<LocationScreen> createState() =>
      _LocationState(nearbyPlaces: nearbyPlaces);
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _LocationState extends State<LocationScreen> {
  final List<plc.PlacesSearchResult> nearbyPlaces;

  _LocationState({required this.nearbyPlaces});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.9),
        onPressed: () {
          displayCurrentLocation();
        },
        child: const Icon(
          Icons.my_location,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Gmap(nearbyPlaces: nearbyPlaces)),
          Positioned(
            top: 20,
            left: 10,
            right: 20,
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Center(
                    child: IconButton(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.black,
                      iconSize: 30,
                    ),
                  ), 
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5,),
                  SvgPicture.asset(
                    'asset/image/RecycleMate logo.svg',
                    height: 60,
                    color: Colors.black,
                  ),/*
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: LocationSearchBox(),
                  ), */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  displayCurrentLocation() async {
    LatLng currentLatLng = await getCurrentLatLng();
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(currentLatLng.latitude, currentLatLng.longitude),
      ),
    );

    if (mounted) {
      setState(() {});
    }
    if (GmapState.gmapState != null) {
      GmapState.gmapState!.googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(currentLatLng.latitude, currentLatLng.longitude),
              zoom: 13),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
