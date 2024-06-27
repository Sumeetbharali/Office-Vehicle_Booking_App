import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class TripService {
  static Future<int> startTrip(double startLatitude, double startLongitude, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/trips/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'start_latitude': startLatitude.toString(),
          'start_longitude': startLongitude.toString(),
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['trip_id'];
      } else {
        throw Exception('Failed to start trip. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to start trip: $e');
    }
  }

  static Future<void> updateLocation(int tripId, double currentLatitude, double currentLongitude, String accessToken) async {
    try {
      await http.post(
        Uri.parse('$baseURL/trips/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'trip_id': tripId,
          'current_latitude': currentLatitude.toString(),
          'current_longitude': currentLongitude.toString(),
        }),
      );
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  static Future<double> endTrip(int tripId, double endLatitude, double endLongitude, int reservationId, double distanceTraveled, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/trips/end'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'trip_id': tripId,
          'end_latitude': endLatitude.toString(),
          'end_longitude': endLongitude.toString(),
          'reservation_id': reservationId.toString(), // Convert to string
          'distance_traveled': distanceTraveled.toString(), // Convert to string
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return double.parse(responseData['distance_traveled'].toString());
      } else {
        throw Exception('Failed to end trip. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to end trip: $e');
    }
  }
}
