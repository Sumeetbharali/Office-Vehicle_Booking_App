

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nic_yaan/services/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
// trip_model.dart
// trip_model.dart

class Trip {
  final int id;
  final int userId;
  final String startLatitude;
  final String startLongitude;
  final String? currentLatitude;
  final String? currentLongitude;
  final String? destination; // Add destination if needed

  Trip({
    required this.id,
    required this.userId,
    required this.startLatitude,
    required this.startLongitude,
    this.currentLatitude,
    this.currentLongitude,
    this.destination,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      startLatitude: json['start_latitude'],
      startLongitude: json['start_longitude'],
      currentLatitude: json['current_latitude'],
      currentLongitude: json['current_longitude'],
      destination: json['destination'],
    );
  }
}


class TripApiService {
  static Future<List<Trip>> fetchTrips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0; // Get user ID from SharedPreferences
    String? accessToken = prefs.getString('access_token'); // Get access token from SharedPreferences

    if (accessToken == null) {
      throw Exception('Access token is null');
    }

    final url = '$baseURL/trips/'; // Replace with your actual API endpoint
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // Include access token in the headers
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> tripList = jsonDecode(response.body)['trips'];
      return tripList.map((trip) => Trip.fromJson(trip)).toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }
}
