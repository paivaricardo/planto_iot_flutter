import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsApiViewWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GoogleMapsApiViewWidget(
      {required this.latitude, required this.longitude, super.key});

  @override
  State<GoogleMapsApiViewWidget> createState() =>
      _GoogleMapsApiViewWidgetState();
}

class _GoogleMapsApiViewWidgetState extends State<GoogleMapsApiViewWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _initialCameraPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 15,
    );
    _markers.add(Marker(
        markerId: const MarkerId('1'),
        position: LatLng(widget.latitude, widget.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      mapType: MapType.hybrid,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }
}
