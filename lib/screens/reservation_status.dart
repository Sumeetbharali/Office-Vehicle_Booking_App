import 'package:flutter/material.dart';

import '../services/reservation_service.dart';
class ReservationStatusScreen extends StatefulWidget {
  const ReservationStatusScreen({Key? key}) : super(key: key);

  @override
  State<ReservationStatusScreen> createState() => _ReservationStatusScreenState();
}

class _ReservationStatusScreenState extends State<ReservationStatusScreen> {
  String _reservationStatus = ''; // State variable to hold reservation status

  @override
  void initState() {
    super.initState();
    fetchAndSetReservationStatus();
  }

  Future<void> fetchAndSetReservationStatus() async {
    try {
      var status = await APIService.fetchReservationStatus();
      setState(() {
        _reservationStatus = status;
      });
    } catch (e) {
      setState(() {
        _reservationStatus = 'Failed to fetch reservation status';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Status'),
      ),
      body: Center(
        child: _reservationStatus.isEmpty
            ? CircularProgressIndicator() // Show loading indicator while fetching data
            : Text(_reservationStatus), // Show reservation status once fetched
      ),
    );
  }
}