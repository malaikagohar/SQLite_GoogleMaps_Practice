import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput(this.onSelectPlace, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectonMap() async {
    final locData = await Location().getLocation();
    final selectedLocation =
        // ignore: use_build_context_synchronously
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => MapScreen(
                  initialLocation: PlaceLocation(
                      latitude: locData.latitude!,
                      longitude: locData.longitude!),
                  isSelecting: true,
                )));
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        alignment: Alignment.center,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        height: 250,
        width: double.infinity,
        child: _previewImageUrl == null
            ? const Text(
                'No Location Chosen',
                textAlign: TextAlign.center,
              )
            : Image.network(_previewImageUrl!,
                fit: BoxFit.cover, width: double.infinity),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(
                Icons.location_on,
              ),
              label: const Text('Current Location')),
          TextButton.icon(
              onPressed: _selectonMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'))
        ],
      )
    ]);
  }
}
