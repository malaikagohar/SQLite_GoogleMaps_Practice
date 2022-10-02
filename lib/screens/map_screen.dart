import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/models/place.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  PlaceLocation? initialLocation;
  final bool isSelecting;

  MapScreen({this.initialLocation, this.isSelecting = false});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  // @override
  // Future<void> initState() async {
  //     final location = await Location().getLocation();
  //     widget.initialLocation = PlaceLocation(latitude: location.latitude!, longitude: location.longitude!);
  //   super.initState();
  // }
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Map'),
          actions: [
            if (widget.isSelecting)
              IconButton(
                icon: Icon(Icons.check),
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      },
              )
          ],
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.initialLocation!.latitude,
                  widget.initialLocation!.longitude),
              zoom: 16),
          onTap: widget.isSelecting ? _selectLocation : null,
          markers: (_pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                      markerId: MarkerId("m1"),
                      position: _pickedLocation ??
                          LatLng(widget.initialLocation!.latitude,
                              widget.initialLocation!.longitude))
                },
        ));
  }
}
