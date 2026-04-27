
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_bloc.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_bloc.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_state.dart';
import 'package:randevu_app/presentation/routes/app_router.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';
import 'package:randevu_app/presentation/widget/paitent_item.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_event.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

 @override
void initState() {
  super.initState();

  final doctorId = context.read<AppointmentBloc>().state.doctorId;

  if (doctorId != null) {
    context.read<AppointmentBloc>().add(
      GetAppointmentsEvent(doctorId),
    );
  }
}

   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
         onPressed: () {
                Navigator.pop(context);
                           },
        ),
        title: const Text(
          "Search Result",
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),

      bottomNavigationBar: FlexibleBar(
        backgroundColor: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        leftWidget: IconButton(
          icon: const Icon(Icons.qr_code_scanner, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const Text(" "),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

     body: BlocBuilder<PatientBloc, PatientState>(
  builder: (context, state) {
    if (state is SearchPatientLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is SearchPatientFailure) {
      return Center(
        child: Text(state.message),
      );
    }

    if (state is SearchPatientNoResults) {
      return Center(
        child: Text(state.message),
      );
    }

    if (state is SearchPatientSuccess) {
      final patients = state.patients;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                
                itemCount: patients.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
itemBuilder: (context, index) {
  final patient = patients[index];

  final appointmentState = context.watch<AppointmentBloc>().state;
final allAppointments = appointmentState.appointments;

  final patientAppointments = allAppointments.where((a) {
    return a.patientId.toString() == patient.id.toString();
  }).toList();
print("Patient ID: ${patient.id}");
print("Appointments Count: ${allAppointments.length}");
for (var a in allAppointments) {
  print("Appt patientId=${a.patientId} date=${a.date}");
}
  patientAppointments.sort((a, b) {
    return b.date.compareTo(a.date);
  });

  final lastAppointment = patientAppointments.isNotEmpty
      ? patientAppointments.first.date
      : "No Appointment";

  return GestureDetector(
    onTap: () {
      context.read<AppointmentBloc>().add(
        SetPatientEvent(patient.id!),
      );

      Navigator.pushNamed(
        context,
        AppRoutes.appointmenttake,
      );
    },
    child: PatientItemWidget(
      number: "${index + 1}",
      name: patient.name,
      id: patient.idNumber ?? "",
      date: lastAppointment,
    ),
  );
},
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: CustomButton.textWithIcon(
                text: "New Patient",
                icon: Icons.add_circle_rounded,
                 onPressed: () =>  AppRouter.navigateTo(context, AppRoutes.newPaitent),
                color: AppColors.primary,
                textStyle: AppTextStyles.bold_16
                    .copyWith(color: AppColors.white),
                iconColor: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }

    return const Center(
      child: Text("Search Patients"),
    );
  },
),
    );
  }


}