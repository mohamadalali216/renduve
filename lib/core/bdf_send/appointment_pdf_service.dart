import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:randevu_app/data/models/paitent_model.dart';
import 'package:randevu_app/data/models/doctor_model.dart';
import 'package:pdf/pdf.dart';
/// Service for generating professional medical appointment PDFs.
/// Fully null-safe and reusable.
class AppointmentPdfService {
  static final primary = PdfColor.fromInt(0xFF2BB7AE);
static final primaryLight = PdfColor.fromInt(0xFF0BFBEB);
static final gray = PdfColor.fromInt(0xFF393939);
static final black = PdfColor.fromInt(0xFF000000);
static final white = PdfColor.fromInt(0xFFFFFFFF);
static final grayLight = PdfColor.fromInt(0xFFE6E6E6);
  // Consistent colors from AppColors, adapted for PDF
  /// Generates appointment confirmation PDF as bytes.
  /// [patient] - Required patient details.
  /// [doctor] - Optional doctor details (name, specialty).
  /// [date], [time], [notes] - Appointment details.
  static Future<Uint8List> generateAppointmentPdf({
    required PatientModel patient,
    DoctorModel? doctor,
    required String date,
    required String time,
    required String notes,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context ctx) {
         
      
          return pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(

                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      '🩺 Randevu Medical Appointment',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
color: primaryLight
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Confirmation',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: primaryLight

                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),

              // Patient Section
              pw.Text(
                'Patient Information',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold,color: primary),
              ),
              pw.SizedBox(height: 8),
              _buildInfoRow('Name', patient.name),
              _buildInfoRow('Age', patient.age?.toString() ?? 'N/A'),
              _buildInfoRow('Gender', patient.gender ?? 'N/A'),
              _buildInfoRow('Phone', patient.phone ?? 'N/A'),
              _buildInfoRow('City', patient.city ?? 'N/A'),
              _buildInfoRow('ID Number', patient.idNumber ?? 'N/A'),
              pw.SizedBox(height: 20),

              // Doctor Section
              pw.Text(
                'Doctor Information',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: primary),
              ),
              pw.SizedBox(height: 8),
              _buildInfoRow('Doctor', doctor?.name ?? 'N/A'),
              _buildInfoRow('Specialty', doctor?.specialty ?? 'N/A'),
              pw.SizedBox(height: 20),

              // Appointment Section
              pw.Text(
                'Appointment Details',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: primary),
              ),
              pw.SizedBox(height: 8),
              _buildInfoRow('Date', date),
              _buildInfoRow('Time', time),
              _buildInfoRow('Notes', notes.isEmpty ? 'None' : notes),

              pw.SizedBox(height: 24),
              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(

                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text('Thank you for choosing Randevu! 📞 Contact us anytime.' , style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold,color: primary),),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Generated on ${DateTime.now().toString().substring(0, 16)}',
                      style: pw.TextStyle(fontSize: 10,color: primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        },
      ),
    );

    return await pdf.save();
  }

  /// Private helper for info rows in PDF.
  static pw.Widget _buildInfoRow(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 120,
              child: pw.Text(
                '$label:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(child: pw.Text(value)),
          ],
        ),
      );
}
