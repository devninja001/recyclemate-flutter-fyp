import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fyp/reusable/googlemap.dart';
import 'package:fyp/screens/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class LocationSearchBox extends StatefulWidget {
  const LocationSearchBox({super.key});

  @override
  State<LocationSearchBox> createState() => _LocationSearchBoxState();
}

class _LocationSearchBoxState extends State<LocationSearchBox> {
  static const kGoogleApiKey = 'AIzaSyDV8_kYoCxFkfIuO-DUGt9istH68HxOZas';

  final Mode _mode = Mode.overlay;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter Your Location',
            suffixIcon: const Icon(Icons.search),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 5, bottom: 5),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black45),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          onTap: _handlePress,
        ),
      ),
    );
  }

  Future<void> _handlePress() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        filled: true,
        alignLabelWithHint: true,
        fillColor: Colors.white,
        hintText: 'Enter Your Location',
        suffixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.only(left: 20, right: 5, bottom: 5),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black45),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [Component(Component.country, 'my')],
    );

    if (p != null) {
      displayPrediction(p, homeScaffoldKey.currentState); //
    } else {}
    //displayPrediction(p?.description as Prediction?, homeScaffoldKey.currentState); //
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.errorMessage!),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('searched'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: detail.result.name,
            snippet: detail.result.formattedPhoneNumber)));

    if (mounted) {
      setState(() {});
    }

    if (GmapState.gmapState != null) {
      GmapState.gmapState!.googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat, lng), zoom: 18)));
    }
  }

  @override
  void dispose() {
    GmapState.gmapState!.googleMapController.dispose();
    super.dispose();
  }
}
