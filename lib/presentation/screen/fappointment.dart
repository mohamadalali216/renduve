import 'package:flutter/material.dart';
import 'package:randevu_app/core/bdf_send/appointment_pdf_service.dart';
import 'package:randevu_app/core/bdf_send/phone_utils.dart';
import 'package:randevu_app/core/bdf_send/share_service.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_bloc.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_state.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_event.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_bloc.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_state.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_event.dart';
import 'package:randevu_app/data/models/doctor_model.dart';

class FinishAppointmentScreen extends StatefulWidget {
  final int? doctorId;
  final int? patientId;
  final String date;
  final String time;
  final String notes;

  const FinishAppointmentScreen({
    super.key,
    this.doctorId,
    this.patientId,
    required this.date,
    required this.time,
    required this.notes,
  });

  @override
  State<FinishAppointmentScreen> createState() => _FinishAppointmentScreenState();
}

class _FinishAppointmentScreenState extends State<FinishAppointmentScreen> {


  @override
void initState() {
  super.initState();
  print('🔥 FAPPOINTMENT: initState');
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.doctorId != null) {
      context.read<DoctorBloc>().add(LoadDoctorsEvent());
    }
    if (widget.patientId != null) {
      context.read<PatientBloc>().add(GetPatientBasicInfoEvent(widget.patientId!));
    }
  });
}

@override
void deactivate() {
  print('🔥 FAPPOINTMENT: deactivate() - صفحة تُحذف من الـ tree');
  super.deactivate();
}

@override
void dispose() {
  print('🔥 FAPPOINTMENT: dispose() - صفحة تُغلق');
  super.dispose();
}//دالة فتح محادثة واتس اب 
Future<void> _shareAppointmentPdf() async {
  // Show loading
  if (!mounted) return;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  // State checks
  final patientState = context.read<PatientBloc>().state;
  if (patientState is! PatientBasicInfoLoaded) {
    if (mounted) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please wait for patient info to load')),
    );
    return;
  }
  final patient = patientState.patient;

  // Doctor
  final doctorState = context.read<DoctorBloc>().state;
  DoctorModel? doctor;
  if (doctorState is DoctorLoaded && widget.doctorId != null) {
    try {
      doctor = doctorState.doctors.firstWhere((d) => d.id == widget.doctorId!);
    } catch (_) {}
  }

  // Generate PDF
  final pdfBytes = await AppointmentPdfService.generateAppointmentPdf(
    patient: patient,
    doctor: doctor,
    date: widget.date,
    time: widget.time,
    notes: widget.notes,
  );

  // Close loading & share
  if (mounted) Navigator.of(context).pop();
  await ShareService.sharePdf(pdfBytes: pdfBytes);

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF shared successfully! Select WhatsApp to send.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
  // Generate professional PDF\n  final pdf = pw.Document();\n\n  pdf.addPage(\n    pw.Page(\n      build: (pw.Context ctx) => pw.Padding(\n        padding: const pw.EdgeInsets.all(24),\n        child: pw.Column(\n          crossAxisAlignment: pw.CrossAxisAlignment.center,\n          children: [\n            // Header\n            pw.Container(\n              padding: const pw.EdgeInsets.all(16),\n              decoration: pw.BoxDecoration(\n                color: PdfColor.fromHex('#1E40AF'),\n                borderRadius: pw.BorderRadius.circular(12),\n              ),\n              child: pw.Column(\n                children: [\n                  pw.Text(\n                    '🩺 Randevu Medical Appointment',\n                    style: pw.TextStyle(\n                      fontSize: 24,\n                      fontWeight: pw.FontWeight.bold,\n                      color: PdfColors.white,\n                    ),\n                  ),\n                  pw.SizedBox(height: 4),\n                  pw.Text(\n                    'Confirmation',\n                    style: pw.TextStyle(\n                      fontSize: 16,\n                      color: PdfColors.white70,\n                    ),\n                  ),\n                ],\n              ),\n            ),\n            pw.SizedBox(height: 24),\n\n            // Patient Section\n            pw.Text('Patient Information', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),\n            pw.SizedBox(height: 8),\n            _buildInfoRow('Name', patient.name, pdf),\n            _buildInfoRow('Age', patient.age?.toString() ?? 'N/A', pdf),\n            _buildInfoRow('Gender', patient.gender ?? 'N/A', pdf),\n            _buildInfoRow('Phone', patient.phone ?? 'N/A', pdf),\n            _buildInfoRow('City', patient.city ?? 'N/A', pdf),\n            _buildInfoRow('ID Number', patient.idNumber ?? 'N/A', pdf),\n            pw.SizedBox(height: 20),\n\n            // Doctor Section\n            pw.Text('Doctor Information', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),\n            pw.SizedBox(height: 8),\n            _buildInfoRow('Doctor', doctorName, pdf),\n            _buildInfoRow('Specialty', specialty, pdf),\n            pw.SizedBox(height: 20),\n\n            // Appointment Section\n            pw.Text('Appointment Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),\n            pw.SizedBox(height: 8),\n            _buildInfoRow('Date', widget.date, pdf),\n            _buildInfoRow('Time', widget.time, pdf),\n            _buildInfoRow('Notes', widget.notes.isEmpty ? 'None' : widget.notes!, pdf),\n\n            pw.SizedBox(height: 24),\n            // Footer\n            pw.Container(\n              padding: const pw.EdgeInsets.all(12),\n              decoration: pw.BoxDecoration(\n                color: PdfColors.grey300,\n                borderRadius: pw.BorderRadius.circular(8),\n              ),\n              child: pw.Column(\n                children: [\n                  pw.Text('Thank you for choosing Randevu! 📞 Contact us anytime.'),\n                  pw.SizedBox(height: 4),\n                  pw.Text('Generated on ${DateTime.now().toString().substring(0, 16)}', style: pw.TextStyle(fontSize: 10)),\n                ],\n              ),\n            ),\n          ],\n        ),\n      ),\n    ),\n  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.white),
          onPressed: () {
            // Restore the search results before navigating back
            context.read<PatientBloc>().add(ReloadLastSearchEvent());
            // Pop back to SearchResultScreen (remove AddAppointmentScreen + FinishAppointmentScreen)
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Finish Appointment",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),

      /// ================= BOTTOM BAR =================
      bottomNavigationBar: FlexibleBar(
        backgroundColor: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        leftWidget: IconButton(
          icon: const Icon(Icons.group, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const SizedBox(),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [

          /// 🔵 الكرت مخفي تمامًا

Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// DOCTOR
            _title("Doctor"),
            const SizedBox(height: 6),
            BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                String doctorName = "Doctor ID: ${widget.doctorId ?? 'N/A'}";
                if (state is DoctorLoaded && widget.doctorId != null) {
                  try {
                    final doctor = state.doctors.firstWhere(
                      (d) => d.id == widget.doctorId,
                    );
                    doctorName = doctor.name;
                  } catch (e) {
                    doctorName = "Doctor not found";
                  }
                } else if (state is DoctorLoading) {
                  doctorName = "Loading...";
                }
                return _blackTag(doctorName);
              },
            ),

            const SizedBox(height: 20),

            BlocBuilder<PatientBloc, PatientState>(
              builder: (context, state) {
                if (state is PatientLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is PatientBasicInfoLoaded) {
                  final p = state.patient;
                  return Column(
                    children: [
                      /// PATIENT INFO ROW 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoColumn("Full Name", p.name),
                          _infoColumn("Age", p.age?.toString() ?? "N/A"),
                          _infoColumn("Gender", p.gender ?? "N/A"),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// PATIENT INFO ROW 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoColumn("City", p.city ?? "N/A"),
                          _infoColumn("ID Number", p.idNumber ?? "N/A"),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// PHONE
              _infoColumn("Phone Number", PhoneUtils.normalizePhone(p.phone)),

                      const SizedBox(height: 20),
                    ],
                  );
                }
                if (state is PatientFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color:AppColors.error, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PatientBloc>().add(GetPatientBasicInfoEvent(widget.patientId!));
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    /// PATIENT INFO ROW 1 - STATIC PLACEHOLDER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoColumn("Full Name", "Loading..."),
                        _infoColumn("Age", "Loading..."),
                        _infoColumn("Gender", "Loading..."),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoColumn("City", "Loading..."),
                        _infoColumn("ID Number", "Loading..."),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _infoColumn("Phone Number", "Loading..."),
                    const SizedBox(height: 20),
                  ],
                );

              },
            ),

            /// DATE & TIME
            Row(
              children: [
                Expanded(
                  child: _greenBox("Date", widget.date),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _greenBox("Time", widget.time),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// NOTES
            _title("Notes"),
            const SizedBox(height: 8),

            Text(
              widget.notes.isNotEmpty ? widget.notes : "No notes",
              style: AppTextStyles.bold_12.copyWith(color: AppColors.white),
            ),

            /// SEND BUTTON
            SizedBox(
              width: double.infinity,
              child: CustomButton.text(
                text: "Send Appointment PDF By WP",
                onPressed: _shareAppointmentPdf,
    /*لارسال الموعد كنص فقط    onPressed: () async {
  final patientState = context.read<PatientBloc>().state;
  final doctorState = context.read<DoctorBloc>().state;

  if (patientState is! PatientBasicInfoLoaded) return;

  final patient = patientState.patient;

  /// ===== رقم الهاتف =====
  String phone = patient.phone ?? "";
  phone = phone.replaceAll(" ", "").replaceAll("-", "");

  if (phone.startsWith("0")) {
    phone = phone.substring(1);
  }

  phone = "963$phone";

  /// ===== اسم الطبيب =====
  String doctorName = "غير معروف";

  if (doctorState is DoctorLoaded && widget.doctorId != null) {
    try {
      doctorName = doctorState.doctors
          .firstWhere((d) => d.id == widget.doctorId)
          .name;
    } catch (_) {}
  }

  /// ===== الرسالة =====
  final msg = """
موعدك الطبي

👨‍⚕️ الطبيب: $doctorName
👤 المريض: ${patient.name}
📅 التاريخ: ${widget.date}
⏰ الوقت: ${widget.time}
📝 الملاحظات: ${widget.notes.isEmpty ? "لا يوجد" : widget.notes}
""";

  final url = Uri.parse(
    "https://wa.me/$phone?text=${Uri.encodeComponent(msg)}",
  );

  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
},*/

                color: AppColors.primary,
                textStyle: AppTextStyles.bold_16
                    .copyWith(color: AppColors.white),
              ),
            ),

            const SizedBox(height: 10),

/// GO TO APPOINTMENTS LIST
  SizedBox(
    width: double.infinity,
    child: CustomButton.text(
      text: "Appointments List",
      onPressed: () async {
        print('🔥 FAPPOINTMENT: Button clicked, doctorId = ${widget.doctorId}');

        if (widget.doctorId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ No doctor selected")),
          );
          return;
        }

        // ✅ Senior Fix: Use async/await for proper flow control
        // Only return true when user actually completes the flow
        if (!mounted) return;

        await Navigator.pushNamed(
          context,
          AppRoutes.appointmentlist,
          arguments: widget.doctorId,
        );

        // ✅ Only consider completed when user returns from list
        // This ensures real flow completion, not fake success
        if (!mounted) return;
        Navigator.pop(context, true);
      },
      color: AppColors.primary,
      textStyle: AppTextStyles.bold_16.copyWith(color: AppColors.white),
    ),
  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 100),  // Bottom padding for safe area
    ],
  ),
));
  }

  /// ================= WIDGETS =================

  Widget _title(String text) {
    return Text(
      text,
      style: AppTextStyles.bold_16
          .copyWith(color: AppColors.primary),
    );
  }

  Widget _blackTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.bold_16
            .copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _greenBox(String title, String value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.white),
        ),
      ],
    );
}


