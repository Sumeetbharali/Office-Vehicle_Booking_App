// user_trips_screen.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/user_trips.dart';


class UserTripsScreen extends StatefulWidget {
  @override
  _UserTripsScreenState createState() => _UserTripsScreenState();
}

class _UserTripsScreenState extends State<UserTripsScreen> {
  List<Trip> trips = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      List<Trip> fetchedTrips = await TripApiService.fetchTrips();
      setState(() {
        trips = fetchedTrips;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
      // Handle the error appropriately
      print('Failed to load trips: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Trips'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return TripCard(trip: trips[index]);
        },
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;

  const TripCard({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Trip ID: ${trip.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${trip.userId}'),
                Text('Start Latitude: ${trip.startLatitude}'),
                Text('Start Longitude: ${trip.startLongitude}'),
                if (trip.currentLatitude != null)
                  Text('Current Latitude: ${trip.currentLatitude}'),
                if (trip.currentLongitude != null)
                  Text('Current Longitude: ${trip.currentLongitude}'),
                if (trip.destination != null)
                  Text('Destination: ${trip.destination}'),
              ],
            ),
          ),
          Container(
            height: 50,
            child: Lottie.asset(
              'assets/images/Animation - 1717416053958.json', // Replace with your Lottie animation asset path
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
