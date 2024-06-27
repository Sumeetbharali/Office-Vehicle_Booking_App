import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nic_yaan/services/constant.dart';

class DriverService {
  static Future<List<Map<String, dynamic>>> fetchApprovedReservations() async {
    var url = Uri.parse('$baseURL/reservations/check');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body)['data'];
      List<Map<String, dynamic>> reservations = [];

      for (var item in responseData) {
        reservations.add({
          'id': item['id'],
          'vehicle_id': item['vehicle_id'],
          'user_id': item['user_id'],
          'departure_time': item['departure_time'],
          'arrival_time': item['arrival_time'],
          'purpose': item['purpose'],
          'status': item['status'],
          'created_at': item['created_at'],
          'updated_at': item['updated_at'],
        });
      }

      return reservations;
    } else {
      throw Exception('Failed to fetch approved reservations');
    }
  }
}
