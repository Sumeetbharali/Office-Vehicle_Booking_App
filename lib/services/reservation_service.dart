import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nic_yaan/services/constant.dart';

class APIService {
  static Future<String> submitReservation({
    required String tripType,
    required String departureTime,
    String? arrivalTime, // Nullable since it's not required for drop_only trips
    required String purpose,
  }) async {
    try {
      // Retrieve user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int user_id = prefs.getInt('user_id') ?? 0; // Default value as 0, change accordingly
      if (user_id == null) {
        return 'User ID not found. Please log in again.';
      }

      var url = Uri.parse(reservationURL); // Adjust the reservation endpoint URL accordingly

      var body = {
        'user_id': user_id,
        'trip_type': tripType,
        'departure_time': departureTime,
        'purpose': purpose,
      };

      if (tripType == 'round_trip' && arrivalTime != null) {
        body['arrival_time'] = arrivalTime;
      }

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return 'Reservation submitted successfully';
      } else if (response.statusCode == 400) {
        return jsonDecode(response.body)['message'] ?? "Vehicle is not available for the specified time period";
      } else {
        return 'Server error. Please try again later.';
      }
    } catch (e) {
      return 'Something went wrong. Please try again later.';
    }
  }

static Future<String> fetchReservationStatus() async {
    try {
      var url = Uri.parse(reservationstatusURL); // Adjust the reservation status endpoint URL accordingly

      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var reservationStatus = data['status'];
        return reservationStatus;
      } else if (response.statusCode == 401) {
        return unauthorized;
      } else {
        return serverError;
      }
    } catch (e) {
      return somethingWentWrong;
    }
  }
}
