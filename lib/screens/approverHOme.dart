import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nic_yaan/screens/user_trip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nic_yaan/screens/booking.dart';
import 'package:nic_yaan/screens/reservation.dart';
import 'package:nic_yaan/screens/reservation_status.dart';
import 'package:nic_yaan/screens/trip.dart';
import 'package:nic_yaan/services/bookings_service.dart';
import 'package:nic_yaan/services/constant.dart';
import '../services/recent_booking_service.dart';
import '../util/glow_button.dart';
import '../util/glow_button2.dart';
import '../util/my_listtile.dart';
import 'approver.dart';
import 'check.dart';
import 'first_approver.dart';

class HomePageApp extends StatefulWidget {
  const HomePageApp({super.key});

  @override
  State<HomePageApp> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageApp> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Guest';
    });
  }

  Future<void> _navigateBasedOnRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');

    if (role == 'first_approver') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstApproverPage(accessToken: '',)),
      );
    } else if (role == 'second_approver') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ApproverPage(accessToken: '',)),
      );
    } else {
      // Handle other roles or show a message if role is not recognized
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role not recognized')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Card with Lottie animation, welcome message, and additional text and button
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Lottie.asset('assets/images/Animation - 1716731596828.json'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Welcome, $userName!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'See Pending Reservation Request',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _navigateBasedOnRole,  // Call the function to navigate based on role
                        child: Text('Check here'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    List_tile(
                      iconPath: 'assets/images/loading-bar.png',
                      title: 'Book',
                      subTitle: 'Your Next Trip',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservationScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    List_tile(
                      iconPath: 'assets/images/sedan.png',
                      title: 'Check',
                      subTitle: 'Vehicle Availability',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CheckAvailabilityPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlowButton(
                      iconPath: 'assets/images/car.png',
                      buttonText: 'Bookings',
                      destinationScreen: TicketScreen(),
                    ),
                    GlowButton(
                      iconPath: 'assets/images/map.png',
                      buttonText: 'Trips',
                      destinationScreen: UserTripsScreen(),
                    ),
                    DialogButton(
                      iconPath: 'assets/images/file.png', // Path to the icon image
                      buttonText: 'Check Status', // Text to display on the button
                      fetchRecentReservationStatus: fetchRecentReservationStatus,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
