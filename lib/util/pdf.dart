import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<File> generateReservationPDF(String status) async {
  final pdf = pw.Document();

  // Add reservation information to PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Reservation Status: $status'),
        );
      },
    ),
  );

  // Save the PDF to the device storage
  final String dir = (await getExternalStorageDirectory())!.path;
  final String path = '$dir/reservation.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());

  return file;
}
