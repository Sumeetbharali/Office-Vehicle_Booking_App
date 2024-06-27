import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nic_yaan/util/pdf.dart';

class DialogButton extends StatelessWidget {
  final String iconPath;
  final String buttonText;
  final Future<String> Function() fetchRecentReservationStatus;

  const DialogButton({
    Key? key,
    required this.iconPath,
    required this.buttonText,
    required this.fetchRecentReservationStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fetchRecentReservationStatus().then((status) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Recent Reservation Status'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: $status'),
                    if (status == 'approved')
                      ElevatedButton(
                        onPressed: () async {
                          // Show confirmation dialog before downloading PDF
                          bool confirmDownload = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Download PDF'),
                                content: Text('Do you want to download the reservation information as a PDF file?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // Cancel download
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true); // Confirm download
                                    },
                                    child: Text('Download'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmDownload == true) {
                            // Generate and save the PDF document
                            File pdfFile = await generateReservationPDF(status);
                            if (pdfFile != null) {
                              // Show confirmation dialog after PDF is saved
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('PDF Saved'),
                                    content: Text('The reservation information has been saved as a PDF file.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Show error dialog if PDF generation failed
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Failed to generate PDF. Please try again later.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Text('Download PDF'),
                      ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        }).catchError((error) {
          // Handle error
          print('Error fetching recent reservation status: $error');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to fetch recent reservation status. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        });
      },
      child: Column(
        children: [
          Container(
            height: 90,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white38,
                  blurRadius: 7,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(iconPath),
            ),
          ),
          SizedBox(height: 10),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
