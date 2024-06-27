import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/bookings_service.dart';
import 'reservation.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  static List<Color> colors = [
    Colors.red,
    Colors.teal,
    Colors.purple,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 217, 241),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Bookings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Reservation>>(
        future: fetchApprovedReservationsByUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reservations found.'));
          } else {
            List<Reservation> reservations = snapshot.data!;
            // Sort the reservations by departureTime in descending order
            reservations.sort((a, b) => b.departureTime.compareTo(a.departureTime));

            return ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return TicketItem(
                  reservation: reservations[index],
                  color: colors[index % colors.length],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
            );
          }
        },
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final Reservation reservation;
  final Color color;

  const TicketItem({Key? key, required this.reservation, required this.color})
      : super(key: key);

  Future<void> generateAndViewPdf(BuildContext context) async {
    final pdf = pw.Document();
    final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final String departureTimeFormatted =
    dateFormat.format(reservation.departureTime);
    final String arrivalTimeFormatted =
    reservation.arrivalTime != null ? dateFormat.format(reservation.arrivalTime!) : 'N/A';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reservation #${reservation.id}',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Purpose: ${reservation.purpose}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Trip Type: ${reservation.tripType}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Departure Time: $departureTimeFormatted',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Arrival Time: $arrivalTimeFormatted',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Status: ${reservation.status}',
                  style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    try {
      // Get the documents directory
      final directory = await getExternalStorageDirectory();
      // Ensure the directory exists
      if (!await Directory(directory!.path).exists()) {
        await Directory(directory.path).create(recursive: true);
      }
      // Create the file
      final file = File('${directory.path}/reservation_${reservation.id}.pdf');
      // Write the PDF
      await file.writeAsBytes(await pdf.save());

      // Show dialog to view or dismiss
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('PDF Downloaded'),
          content: Text('Reservation #${reservation.id} PDF has been downloaded.'),
          actions: <Widget>[
            TextButton(
              child: Text('View'),
              onPressed: () {
                // Open the PDF file using a third-party app
                OpenFile.open(file.path);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error generating or opening PDF: $e');
      // Show an error dialog or message if PDF generation or opening fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to generate or open PDF.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final String departureTimeFormatted =
    dateFormat.format(reservation.departureTime);
    final String arrivalTimeFormatted =
    reservation.arrivalTime != null ? dateFormat.format(reservation.arrivalTime!) : 'N/A';

    return GestureDetector(
      onTap: () => generateAndViewPdf(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: double.infinity,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: color,
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Reservation #${reservation.id}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purpose: ${reservation.purpose}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('Trip Type: ${reservation.tripType}'),
                        const SizedBox(height: 5),
                        Text('Departure Time: $departureTimeFormatted'),
                        const SizedBox(height: 5),
                        Text('Arrival Time: $arrivalTimeFormatted'),
                        const SizedBox(height: 5),
                        Text('Status: ${reservation.status}'),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () => generateAndViewPdf(context),
                          child: Text('Download PDF'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CustomPaint(
              painter: SideCutsDesign(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
            CustomPaint(
              painter: DottedInitialPath(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
            CustomPaint(
              painter: DottedMiddlePath(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfViewScreen extends StatelessWidget {
  final String filePath;

  const PdfViewScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View PDF'),
      ),
      body: Center(
        child: PDFView(
          filePath: filePath,
        ),
      ),
    );
  }
}

class DottedMiddlePath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 170, 217, 241)
      ..strokeWidth = 1;

    while (startY < size.height - 10) {
      canvas.drawCircle(Offset(size.width / 5, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedInitialPath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 170, 217, 241)
      ..strokeWidth = 1;

    while (startY < size.height - 10) {
      canvas.drawCircle(Offset(0, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SideCutsDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {


    var h = size.height;
    var w = size.width;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(0, h / 2), radius: 18),
      0,
      10,
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color.fromARGB(255, 170, 217, 241),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w, h / 2), radius: 18),
      0,
      10,
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color.fromARGB(255, 170, 217, 241),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w / 5, h), radius: 7),
      0,
      10,
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color.fromARGB(255, 170, 217, 241),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w / 5, 0), radius: 7),
      0,
      10,
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color.fromARGB(255, 170, 217, 241),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(0, h), radius: 7),
      0,
      10,
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color.fromARGB(255, 170, 217, 241),
    );
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, 0), radius: 7),
      0,
      10,
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color.fromARGB(255, 170, 217, 241),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
