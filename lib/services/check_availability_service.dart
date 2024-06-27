import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constant.dart';

class AvailabilityService {
  static Future<String> checkAvailability(String vehicleId, String startTime, String endTime) async {
    final String checkURL = '$baseURL/reservations/check_reservation';

    final response = await http.post(
      Uri.parse(checkURL),
      body: {
        'vehicle_id': vehicleId,
        'start_time': startTime,
        'end_time': endTime,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to check availability');
    }
  }
}
