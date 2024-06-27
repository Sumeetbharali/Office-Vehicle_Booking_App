import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/settings.dart';
import '../services/first_approver_service.dart'; // Import the ApproverService and PendingReservation

class FirstApproverPage extends StatefulWidget {
  const FirstApproverPage({Key? key, required String accessToken}) : super(key: key);

  @override
  State<FirstApproverPage> createState() => _FirstApproverPageState();
}

class _FirstApproverPageState extends State<FirstApproverPage> {
  List<PendingReservation> pendingReservations = []; // List to store pending reservations
  late String accessToken; // Access token variable
  late int userId; // User ID variable

  @override
  void initState() {
    super.initState();
    // Fetch access token and user ID when the page is loaded
    fetchAccessTokenAndUserId();
  }

  void fetchAccessTokenAndUserId() async {
    try {
      // Retrieve access token and user ID from shared preferences
      accessToken = await getAccessToken();
      userId = await getUserId();
      if (accessToken.isNotEmpty) {
        // Fetch pending reservations when access token is retrieved
        fetchPendingReservations();
      } else {
        print('Access token is null or empty');
      }
    } catch (e) {
      print('Error fetching access token or user ID: $e');
    }
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  void fetchPendingReservations() async {
    try {
      final List<PendingReservation> reservations = await ApproverServiceF.fetchPendingReservations(accessToken);
      setState(() {
        // Filter reservations based on status and HOD ID
        pendingReservations = reservations.where((reservation) =>
        reservation.status == 'pending_first_approval' && reservation.hod == userId).toList();
      });
    } catch (e) {
      print('Error fetching pending reservations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: pendingReservations.length,
        itemBuilder: (context, index) {
          PendingReservation reservation = pendingReservations[index];
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
                  Text('Trip Type: ${reservation.tripType}', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await ApproverServiceF.approveReservation(reservation.id, accessToken);
                            // Update UI if reservation is approved
                            setState(() {
                              reservation.status = 'approved';
                            });
                            // Refresh pending reservations list
                            fetchPendingReservations();
                          } catch (e) {
                            print('Failed to approve reservation: $e');
                          }
                        },
                        child: Text('Approve'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await ApproverServiceF.rejectReservation(reservation.id, accessToken);
                            // Update UI if reservation is rejected
                            setState(() {
                              reservation.status = 'rejected';
                            });
                            // Refresh pending reservations list
                            fetchPendingReservations();
                          } catch (e) {
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
