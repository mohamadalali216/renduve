import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for sharing PDFs via system share sheet.
/// User selects WhatsApp or other apps.
class ShareService {
  /// Shares PDF bytes as file via share sheet.
  /// Creates temp file automatically.
  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    String text = 'Your medical appointment details from Randevu app',
    String subject = 'Appointment Confirmation',
  }) async {
    // Save to temp dir
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/randevu_appointment.pdf');
    await file.writeAsBytes(pdfBytes);

    // Share via system sheet (user picks WhatsApp)
    await Share.shareXFiles(
      [XFile(file.path)],
      text: text,
      subject: subject,
    );

    // Clean up temp file (optional, OS handles)
    // await file.delete();
  }
}
