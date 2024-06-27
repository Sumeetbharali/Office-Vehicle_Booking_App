import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nic_yaan/services/constant.dart';
class Reservation {
  final int id;
  final int vehicleId;
  final int userId;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final String purpose;
  final String status;
  final String tripType; // Add this field
  final DateTime createdAt;
  final DateTime updatedAt;

  Reservation({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.departureTime,
    required this.arrivalTime,
    required this.purpose,
    required this.status,
    required this.tripType, // Add this field
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      userId: json['user_id'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: json['arrival_time'] != null ? DateTime.parse(json['arrival_time']) : null,
      purpose: json['purpose'],
      status: json['status'],
      tripType: json['trip_type'], // Add this line
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}


Future<int> getUserIdFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userId = prefs.getInt('user_id') ?? 0; // Default value as 0, change accordingly
  return userId;
}

Future<Reservation> fetchReservationById(int reservationId) async {
  final response = await http.get(Uri.parse('$reservationURL/$reservationId'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    Reservation reservation = Reservation.fromJson(data);
    return reservation;
  } else {
    throw Exception('Failed to load reservation');
  }
}
Future<List<Reservation>> fetchApprovedReservationsByUser() async {
  int userId = await getUserIdFromSharedPreferences();

  final response = await http.get(Uri.parse('$reservationstatusURL?user_id=$userId'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body)['data'];
    List<Reservation> reservations = responseData.map((json) => Reservation.fromJson(json as Map<String, dynamic>)).toList();
    return reservations;
  } else {
    throw Exception('Failed to load reservations');
  }
}

void getReservation(int reservationId) async {
  try {
    Reservation reservation = await fetchReservationById(reservationId);
    print('Reservation ID: ${reservation.id}');
    print('Trip Type: ${reservation.tripType}');
    // You can display this data in your UI as needed
  } catch (e) {
    print('Error: $e');
  }
}
