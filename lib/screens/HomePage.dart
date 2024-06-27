import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:nic_yaan/screens/booking.dart';
import 'package:nic_yaan/screens/reservation.dart';
import 'package:nic_yaan/screens/reservation_status.dart';
import 'package:nic_yaan/screens/trip.dart';
import 'package:nic_yaan/screens/user_trip.dart';
import 'package:nic_yaan/services/bookings_service.dart';
import 'package:nic_yaan/services/constant.dart';

import '../services/recent_booking_service.dart';
import '../util/glow_button.dart';
import '../util/glow_button2.dart';
import '../util/my_listtile.dart';
import 'check.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child:Column(children: [
          const SizedBox(height:20),



          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                List_tile(
                  iconPath: 'assets/images/loading-bar.png',
                  title: 'Book ',
                  subTitle: 'Your Next Trip  ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReservationScreen()),
                    );
                  },
                ),
                SizedBox(height: 40,),
                List_tile(iconPath: 'assets/images/sedan.png',
                  title: 'Check',
                  subTitle: 'Vehicle Availability',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckAvailabilityPage()),
                    );
                  },),
              ],
            ),
          ),
          SizedBox(height:45,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlowButton
                  (iconPath: 'assets/images/car.png', buttonText: 'Bookings',destinationScreen: TicketScreen(),),

                GlowButton
                  (iconPath: 'assets/images/map.png', buttonText: 'Trips',destinationScreen: UserTripsScreen(),),
                DialogButton(
                  iconPath: 'assets/images/file.png', // Path to the icon image
                  buttonText: 'Check Status', // Text to display on the button
                    fetchRecentReservationStatus: fetchRecentReservationStatus,
                ),
              ],
            ),
          ),
        ]
          ,)
        ,),
    );
  }
}

