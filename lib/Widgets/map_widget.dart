import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch initial location
    _initLocationTracking(); // Start tracking live location updates
  }

  Future<void> _getCurrentLocation() async {
    try {
      final PermissionStatus permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
        });
      } else {
        print("Location permission denied");
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;


    if (_currentPosition != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15,
        ),
      );
    }
  }

  void _initLocationTracking() async {
    final PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } else {
      print("Location permission denied");
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true, // Enable My Location Layer
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition?.latitude ?? 20.5937,
                _currentPosition?.longitude ?? 78.9629,
              ),
              zoom: 15,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Current Location: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
