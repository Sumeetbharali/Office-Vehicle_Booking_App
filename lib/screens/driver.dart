import 'package:flutter/material.dart';
import 'package:nic_yaan/screens/trip.dart';
import '../pages/settings.dart';
import '../services/driver_services.dart'; // Import the DriverService

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  List<Map<String, dynamic>> approvedReservations = [];

  @override
  void initState() {
    super.initState();
    fetchApprovedReservations();
  }

  Future<void> fetchApprovedReservations() async {
    try {
      List<Map<String, dynamic>> reservations =
      await DriverService.fetchApprovedReservations();
      setState(() {
        approvedReservations = reservations;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(
        title: Text('Driver Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: approvedReservations.length,
        itemBuilder: (context, index) {
          var reservation = approvedReservations[index];
          return Card(
            color: Colors.deepPurple.shade100,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                'Reservation ID: ${reservation['id']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Text('Purpose: ${reservation['purpose']}'),
                  SizedBox(height: 4.0),
                  Text('Vehicle: ${reservation['vehicle_id']}'),
                  SizedBox(height: 4.0),
                  Text('Departure Time: ${reservation['departure_time']}'),
                  SizedBox(height: 4.0),
                  Text('Arrival Time: ${reservation['arrival_time']}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TripPage()),
                  );
                },
                child: Text('Take Trip'),
              ),
            ),
          );
        },
      ),
    );
  }
}
