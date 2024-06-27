import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/My_button2.dart';
import '../services/reservation_service.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController departureTimeController;
  late TextEditingController arrivalTimeController;
  late TextEditingController purposeController;
  String selectedTripType = 'round_trip';

  @override
  void initState() {
    super.initState();
    departureTimeController = TextEditingController();
    arrivalTimeController = TextEditingController();
    purposeController = TextEditingController();
  }

  @override
  void dispose() {
    departureTimeController.dispose();
    arrivalTimeController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              DropdownButtonFormField<String>(
                value: selectedTripType,
                onChanged: (newValue) {
                  setState(() {
                    selectedTripType = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'round_trip',
                    child: Text('Round Trip'),
                  ),
                  DropdownMenuItem(
                    value: 'drop_only',
                    child: Text('Drop Only'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Trip Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  labelText: 'Departure Time (HH:MM)',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        departureTimeController.text =
                        '${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}';
                      });
                    }
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a departure time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (selectedTripType == 'round_trip') ...[
                TextFormField(
                  controller: arrivalTimeController,
                  decoration: InputDecoration(
                    labelText: 'Arrival Time (HH:MM)',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          arrivalTimeController.text =
                          '${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}';
                        });
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an arrival time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
              ],
              TextFormField(
                controller: purposeController,
                decoration: InputDecoration(
                  labelText: 'Purpose',
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid purpose';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the form data and submit the reservation
                    submitReservation(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void submitReservation(BuildContext context) async {
    // Format departure and arrival times
    DateTime departureDateTime = DateFormat('yyyy-MM-dd HH:mm')
        .parse(departureTimeController.text);
    String formattedDepartureTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(departureDateTime);

    String? formattedArrivalTime;
    if (selectedTripType == 'round_trip') {
      DateTime arrivalDateTime = DateFormat('yyyy-MM-dd HH:mm')
          .parse(arrivalTimeController.text);
      formattedArrivalTime = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(arrivalDateTime);
    }

    // Implement the logic to submit the reservation to the server
    try {
      var response = await APIService.submitReservation(
        tripType: selectedTripType,
        departureTime: formattedDepartureTime,
        arrivalTime: formattedArrivalTime,
        purpose: purposeController.text,
      );

      if (response == 'Reservation submitted successfully') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Reservation Successful'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit reservation')),
      );
    }
  }

}
