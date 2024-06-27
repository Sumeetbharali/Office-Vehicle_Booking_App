import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package in pubspec.yaml
import '../services/check_availability_service.dart';

class CheckAvailabilityPage extends StatefulWidget {
  @override
  _CheckAvailabilityPageState createState() => _CheckAvailabilityPageState();
}

class _CheckAvailabilityPageState extends State<CheckAvailabilityPage> {
  String availabilityMessage = '';
  String selectedVehicleId = '1';
  DateTime? startDateTime;
  DateTime? endDateTime;
  final List<String> vehicleOptions = ['1', '2', '3'];

  Future<void> _pickStartDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _pickEndDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _checkAvailability() async {
    if (startDateTime == null || endDateTime == null) {
      setState(() {
        availabilityMessage = 'Please select both start and end times.';
      });
      return;
    }

    try {
      String message = await AvailabilityService.checkAvailability(
        selectedVehicleId,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime!),
        DateFormat('yyyy-MM-dd HH:mm:ss').format(endDateTime!),
      );
      setState(() {
        availabilityMessage = message;
      });
    } catch (e) {
      setState(() {
        availabilityMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Availability'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final String? selected = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Select Vehicle'),
                        children: vehicleOptions.map((String option) {
                          return SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, option);
                            },
                            child: Text(option),
                          );
                        }).toList(),
                      );
                    },
                  );
                  if (selected != null) {
                    setState(() {
                      selectedVehicleId = selected;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Vehicle',
                      hintText: selectedVehicleId,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickStartDateTime,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Start DateTime',
                      hintText: startDateTime == null
                          ? 'Pick Start DateTime'
                          : DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime!),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickEndDateTime,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'End DateTime',
                      hintText: endDateTime == null
                          ? 'Pick End DateTime'
                          : DateFormat('yyyy-MM-dd HH:mm:ss').format(endDateTime!),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: _checkAvailability,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Check Availability'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                availabilityMessage,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
