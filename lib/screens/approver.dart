import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/settings.dart';
import '../services/approver_service.dart'; // Import the ApproverService and PendingReservation

class ApproverPage extends StatefulWidget {
  const ApproverPage({Key? key, required String accessToken}) : super(key: key);

  @override
  State<ApproverPage> createState() => _ApproverPageState();
}

class _ApproverPageState extends State<ApproverPage> {
  List<PendingReservation> pendingReservations = []; // List to store pending reservations
  late String accessToken; // Access token variable

  @override
  void initState() {
    super.initState();
    // Fetch access token when the page is loaded
    fetchAccessToken();
  }

  void fetchAccessToken() async {
    try {
      // Retrieve access token from shared preferences
      accessToken = await getAccessToken();
      if (accessToken.isNotEmpty) {
        // Fetch pending reservations when access token is retrieved
        fetchPendingReservations();
      } else {
        print('Access token is null or empty');
        // Handle error
      }
    } catch (e) {
      print('Error fetching access token: $e');
      // Handle error
    }
  }

  Future<String> getAccessToken() async {
    // Retrieve access token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  void fetchPendingReservations() async {
    try {
      // Fetch pending reservations using the retrieved access token
      final List<PendingReservation> reservations = await ApproverService.fetchPendingReservations(accessToken);
      setState(() {
        pendingReservations = reservations;
      });
    } catch (e) {
      print('Error fetching pending reservations: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out the approved reservations
    final List<PendingReservation> pendingReservationsFiltered = pendingReservations.where((reservation) => reservation.status != 'approved').toList();

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(
        title: Text('Approver Page'),
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
        itemCount: pendingReservationsFiltered.length,
        itemBuilder: (context, index) {
          PendingReservation reservation = pendingReservationsFiltered[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Colors.deepPurple.shade400, // Background color
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Reservation ID: ${reservation.id}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white), // Text color
                  ),
                  SizedBox(height: 8.0),
                  Text('Vehicle ID: ${reservation.vehicleId}', style: TextStyle(color: Colors.white)),
                  Text('User ID: ${reservation.userId}', style: TextStyle(color: Colors.white)),
                  Text('Departure Time: ${reservation.departureTime.toString()}', style: TextStyle(color: Colors.white)),
                Text('Arrival Time: ${reservation.arrivalTime != null ? reservation.arrivalTime.toString() : 'N/A'}', style: TextStyle(color: Colors.white)),
                  Text('Purpose: ${reservation.purpose}', style: TextStyle(color: Colors.white)),
                  Text('Status: ${reservation.status}', style: TextStyle(color: Colors.white)),
                  Text('HOD: ${reservation.hod}', style: TextStyle(color: Colors.white)),
                  Text('Trip Type:${reservation.trip_type}',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await ApproverService.approveReservation(reservation.id, accessToken);
                            // Update UI if reservation is approved
                            setState(() {
                              // Update status locally
                              reservation.status = 'approved';
                            });
                            // Refresh pending reservations list
                            fetchPendingReservations();
                          } catch (e) {
                            // Handle error
                            print('Failed to approve reservation: $e');
                          }
                        },
                        child: Text('Approve'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await ApproverService.rejectReservation(reservation.id, accessToken);
                            // Update UI if reservation is rejected
                            setState(() {
                              // Update status locally
                              reservation.status = 'rejected';
                            });
                            // Refresh pending reservations list
                            fetchPendingReservations();
                          } catch (e) {
                            // Handle error
                            print('Failed to reject reservation: $e');
                          }
                        },
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
