import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/TripService.dart'; // Assuming TripService.dart is in your project

enum TripState {
  notStarted,
  ongoing,
  ended,
}

class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int? tripId;
  String accessToken = '';
  late LatLng _center;
  GoogleMapController? mapController;
  Set<Marker> _markers = {};
  TripState _tripState = TripState.notStarted;
  StreamSubscription<Position>? locationSubscription;
  double totalDistanceTraveled = 0;

  @override
  void initState() {
    super.initState();
    _getAccessToken();
    _getCurrentLocation();

    // Listen to location updates
    locationSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('current'),
            position: _center,
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('access_token') ?? '';
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _startTrip() async {
    try {
      final id = await TripService.startTrip(_center.latitude, _center.longitude, accessToken);
      setState(() {
        tripId = id;
        _tripState = TripState.ongoing;
      });
      print('Trip started. Trip ID: $id');
    } catch (e) {
      print('Failed to start trip: $e');
    }
  }

  Future<void> _updateLocation() async {
    if (tripId != null) {
      try {
        await TripService.updateLocation(tripId!, _center.latitude, _center.longitude, accessToken);
        print('Location updated successfully');
      } catch (e) {
        print('Failed to update location: $e');
      }
    } else {
      print('Please start the trip first');
    }
  }

  Future<void> _endTrip() async {
    if (tripId != null) {
      try {
        // Calculate the total distance traveled
        double distanceTraveled = await _calculateDistanceTraveled();
        // Replace these with actual values during implementation
        await TripService.endTrip(tripId!, _center.latitude, _center.longitude, tripId!, distanceTraveled, accessToken);
        print('Trip ended successfully');
        print('Distance Traveled: $distanceTraveled');
        setState(() {
          totalDistanceTraveled = distanceTraveled;
          tripId = null;
          _tripState = TripState.ended;
        });
        _showTripSummaryDialog(distanceTraveled);
      } catch (e) {
        print('Failed to end trip: $e');
      }
    } else {
      print('Please start the trip first');
    }
  }

  Future<double> _calculateDistanceTraveled() async {
    if (_markers.isNotEmpty) {
      double totalDistance = 0;
      for (int i = 0; i < _markers.length - 1; i++) {
        LatLng start = _markers.elementAt(i).position;
        LatLng end = _markers.elementAt(i + 1).position;
        totalDistance += await Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude);
      }
      return totalDistance / 1000; // Convert meters to kilometers
    } else {
      return 0;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('current'),
          position: _center,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  void _showTripSummaryDialog(double distanceTraveled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Trip Summary"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip Ended',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Total Distance Traveled: ${distanceTraveled.toStringAsFixed(2)} km',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip App'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_tripState == TripState.notStarted)
                  ElevatedButton(
                    onPressed: _startTrip,
                    child: Text('Start Trip'),
                  ),
                if (_tripState == TripState.ongoing)
                  ElevatedButton(
                    onPressed: _updateLocation,
                    child: Text('Update Location'),
                  ),
                if (_tripState == TripState.ongoing)
                  ElevatedButton(
                    onPressed: () => _endTripDialog(context),
                    child: Text('End Trip'),
                  ),
              ],
            ),
          ),
          if (_tripState == TripState.ended)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Trip Ended',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Total Distance Traveled: ${totalDistanceTraveled.toStringAsFixed(2)} km',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _endTripDialog(BuildContext context) async {
    TextEditingController reservationIdController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("End Trip"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Reservation ID:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: reservationIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Reservation ID',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                double distanceTraveled = await _calculateDistanceTraveled();
                try {
                  await TripService.endTrip(
                    tripId!,
                    _center.latitude,
                    _center.longitude,
                    int.parse(reservationIdController.text),
                    distanceTraveled,
                    accessToken,
                  );
                  print('Trip ended successfully');
                  print('Distance Traveled: $distanceTraveled');
                  setState(() {
                    totalDistanceTraveled = distanceTraveled;
                    tripId = null;
                    _tripState = TripState.ended;
                  });
                  Navigator.of(context).pop();
                  _showTripSummaryDialog(distanceTraveled);
                } catch (e) {
                  print('Failed to end trip: $e');
                }
              },
              child: Text('End Trip'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
