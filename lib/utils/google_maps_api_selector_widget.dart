import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';

class GoogleMapsAPISelectorWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const GoogleMapsAPISelectorWidget({this.latitude, this.longitude, super.key});

  @override
  State<GoogleMapsAPISelectorWidget> createState() =>
      _GoogleMapsAPISelectorWidgetState();
}

class _GoogleMapsAPISelectorWidgetState
    extends State<GoogleMapsAPISelectorWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _initialCameraPosition;
  late LatLng? _selectedLatLng; // Store the selected latitude and longitude
  Set<Marker> _markers = {}; // Store the set of markers on the map
  bool _localizacaoAdquirida = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    if (widget.latitude != null || widget.longitude != null) {
      _selectedLatLng = LatLng(widget.latitude!, widget.longitude!);

      setState(() {
        _addMarker();
      });

      _initialCameraPosition = CameraPosition(
        target: LatLng(widget.latitude!, widget.longitude!),
        zoom: 15,
      );
    } else {
      _selectedLatLng = null;
      _initialCameraPosition = const CameraPosition(
        target: LatLng(-15.767158, -47.892950),
        zoom: 15,
      );

      _determinarPosicaoAtualUsuario()
          .then((novaPosicao) async => _moverCameraNovaPosicao(novaPosicao));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      persistentFooterButtons: [
        _buildCancelarButton(),
        _buildAceitarButton(),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                PlantoIOTTitleComponent(size: 18),
                Text("Localizar Sensor/Atuador",
                    style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => _showHelpDialog(context),
              icon: const Icon(Icons.help_outline_rounded,
                  color: Colors.white, size: 24)),
        ],
        flexibleSpace: const PlantoIOTAppBarBackground());
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.hybrid,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            onLongPress: (LatLng latLng) {
              setState(() {
                _localizacaoAdquirida = true;
                _selectedLatLng = latLng;
                _errorText = null;
                _addMarker(); // Add a marker at the selected latitude and longitude
              });
            },
          ),
        ),
        if (_errorText != null)
          Text(_errorText!,
              style: const TextStyle(
                  fontFamily: "Josefin Sans",
                  fontSize: 16.0,
                  color: Colors.red)),
        if (!_localizacaoAdquirida)
          const Text(
              'Clique e segure no local desejado no mapa para selecionar a localização do sensor/atuador.',
              style: TextStyle(fontFamily: 'Josefin Sans', fontSize: 24.0)),
        if (_localizacaoAdquirida)
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SelectableText(
                  'Localização selecionada: Latitude: ${_selectedLatLng!.latitude}, Longitude: ${_selectedLatLng!.longitude}',
                  style: const TextStyle(
                      fontFamily: "Josefin Sans", fontSize: 16.0),
                ),
                const Text(
                  'Clique no botão "Aceitar", para confirmar a localização selecionada.',
                  style: TextStyle(fontFamily: 'Josefin Sans', fontSize: 24.0),
                )
              ],
            ),
          ),
      ],
    );
  }

  _buildCancelarButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancelar'));
  }

  _buildAceitarButton() {
    return TextButton(
        onPressed: () {
          if (_selectedLatLng != null) {
            Navigator.of(context).pop(_selectedLatLng);
          } else {
            setState(() {
              _errorText = 'Selecione uma localização no mapa!';
            });
          }
        },
        child: const Text('Aceitar'));
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text(
              'Sobre',
              style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Esta tela permite que você cadastre, monitore e controle seus sensores e atuadores para uso agrícola. Ainda está em construção. Volte em breve para novidades.',
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  void _addMarker() {
    _markers = {}; // Clear the existing markers
    _markers.add(
      Marker(
        markerId: const MarkerId('selectedLocation'),
        position: _selectedLatLng!,
      ),
    );
  }

  Future<Position> _determinarPosicaoAtualUsuario() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _moverCameraNovaPosicao(Position value) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 15)));
  }
}
