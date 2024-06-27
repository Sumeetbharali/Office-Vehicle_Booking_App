import 'package:http/http.dart' as http;
import 'package:nic_yaan/services/constant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> fetchRecentReservationStatus() async {
  try {
    // Retrieve user_id from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    // Make an HTTP GET request to fetch the recent reservation status
    final response = await http.get(Uri.parse('$baseURL/reservations/byuser1?user_id=$userId'));

    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      final jsonData = json.decode(response.body);
      // Assuming the status is stored in a key called "status" in the response JSON
      final String status = jsonData['status'];
      return status;
    } else {
      // If the request is not successful, throw an exception
      throw Exception('Failed to load recent reservation status');
    }
  } catch (error) {
    // Handle any errors that occur during the process
    print('Error fetching recent reservation status: $error');
    throw error;
  }
}
