import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/reusable/logoutprompt.dart';
import 'package:fyp/screens/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as plc;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<plc.PlacesSearchResult> _placesList = [];
  String placeM = '';
  static const googleApiKey = 'AIzaSyDV8_kYoCxFkfIuO-DUGt9istH68HxOZas';

  final _places = plc.GoogleMapsPlaces(apiKey: googleApiKey);

  @override
  void initState() {
    super.initState();
    placeDetail();

    searchPlacesAndUpdateList("recycling center");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Page",
        ),
        backgroundColor: const Color(0xFF99d578),
        automaticallyImplyLeading: false,
        actions: const [LogOutPrompt()],
      ),
      extendBody: false,
      body: SingleChildScrollView(
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                const Divider(
                  height: 2,
                  color: Colors.black87,
                ),
                GestureDetector(
                  child: Container(
                    //color: const Color(0xFFD5F0C1),
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 30,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Current Location',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            placeM,
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationScreen(
                          nearbyPlaces: _placesList,
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.home_outlined,
                      size: 35,
                      color: Colors.green.shade400,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Nearby Recycling Centres',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.shade400,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _placesList.length,
                    itemBuilder: (context, index) {
                      final place = _placesList[index];
                      return ListTile(
                        tileColor: const Color(0xFFC1F2B0),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black87,
                            width: 0.5,
                          ),
                        ),
                        enableFeedback: true,
                        leading: const Icon(Icons.home_outlined),
                        subtitle: Text(place.vicinity.toString()),
                        title: Text(
                          place.name,
                        ),
                        trailing: Column(
                          children: [
                            Text(place.rating.toString()),
                            if (place.rating.toString() == "5")
                              const Icon(Icons.star),
                            if (place.rating.toString() != "5" &&
                                place.rating.toString() != "0")
                              const Icon(Icons.star_half_sharp),
                            if (place.rating.toString() == "0")
                              const Icon(Icons.star_border_sharp)
                          ],
                        ),
                        onTap: () {
                          openMap(place.name);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  placeDetail() async {
    LatLng currlocation = await getCurrentLatLng();
    List<Placemark> placemark = await placemarkFromCoordinates(
        currlocation.latitude, currlocation.longitude);
    setState(
      () {
        placeM =
            " ${placemark.first.name} ${placemark.first.postalCode} ${placemark.first.locality} ${placemark.first.administrativeArea} ${placemark.first.country}";
      },
    );
    return currlocation;
  }

  Future<List<plc.PlacesSearchResult>> searchPlaces(
      String query, LatLng location) async {
    final result = await _places.searchNearbyWithRadius(
      plc.Location(lat: location.latitude, lng: location.longitude),
      5000,
      type: "point_of_interest",
      keyword: query,
    );

    if (result.status == "OK") {
      return result.results;
    } else {
      throw Exception(result.errorMessage);
    }
  }

  Future<void> searchPlacesAndUpdateList(String keyword) async {
    try {
      LatLng currLocation = await getCurrentLatLng();
      List<plc.PlacesSearchResult> results =
          await searchPlaces(keyword, currLocation);
      setState(() {
        _placesList = results;
      });
    } catch (e) {
      log('$e');
    }
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

  @override
  void dispose() {
    super.dispose();
  }
}

Future<LatLng> getCurrentLatLng() async {
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

    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    Position position =
        await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
    return LatLng(position.latitude, position.longitude);
  }
}
