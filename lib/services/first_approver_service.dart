import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nic_yaan/services/constant.dart';

class ApproverServiceF {
  static Future<void> approveReservation(int id, String accessToken) async {
    final response = await http.post(
      Uri.parse('$baseURL/reservations/$id/approve'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': 'approved'}),
    );
    if (response.statusCode == 200) {
      print('Reservation approved successfully');
    } else {
      print('Failed to approve reservation');
    }
  }

  static Future<void> rejectReservation(int id, String accessToken) async {
    final response = await http.post(
      Uri.parse('$baseURL/reservations/$id/approve'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': 'rejected'}),
    );
    if (response.statusCode == 200) {
      print('Reservation rejected successfully');
    } else {
      print('Failed to reject reservation');
    }
  }

  static Future<List<PendingReservation>> fetchPendingReservations(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseURL/reservations/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => PendingReservation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pending reservations');
    }
  }
}

class PendingReservation {
  final int id;
  final int vehicleId;
  final int userId;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final String purpose;
  final String tripType;
  final int hod;
  String status;

  PendingReservation({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.departureTime,
    required this.arrivalTime,
    required this.purpose,
    required this.tripType,
    required this.hod,
    this.status = 'pending',
  });

  factory PendingReservation.fromJson(Map<String, dynamic> json) {
    return PendingReservation(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      userId: json['user_id'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: json['arrival_time'] != null ? DateTime.parse(json['arrival_time']) : null,
      purpose: json['purpose'],
      status: json['status'],
      tripType: json['trip_type'],
      hod: json['first_approver_id'],
    );
  }
}
