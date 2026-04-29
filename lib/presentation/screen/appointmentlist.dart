import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_bloc.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_event.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_state.dart';
import 'package:randevu_app/presentation/widget/appointment_item.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';

class AppointmentsListScreen extends StatefulWidget {
  final int doctorId;

  const AppointmentsListScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(
          GetAppointmentsEvent(widget.doctorId),
        );
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Appointments List",
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
          icon: const Icon(Icons.person_search_rounded, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const Text(" "),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu_open_outlined, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// DATE HEADER
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                final date = state.selectedDate;
                final dateText = date != null
                    ? '${date.day}.${date.month}.${date.year}'
                    : '--.--.----';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                      onPressed: () {
                        context.read<AppointmentBloc>().add(PreviousDayEvent());
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateText,
                      style: AppTextStyles.bold_10.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: AppColors.white),
                      onPressed: () {
                        context.read<AppointmentBloc>().add(NextDayEvent());
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            /// APPOINTMENTS LIST
            Expanded(
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  if (state.isGetLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.error != null) {
                    return Center(
                      child: Text(
                        state.error!,
                        style: AppTextStyles.bold_16
                            .copyWith(color: AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final selectedDate = state.selectedDate;
                  final allAppointments = state.appointments;
                  final filtered = selectedDate == null
                      ? allAppointments
                      : allAppointments.where((item) {
                          try {
                            final itemDate = DateTime.parse(item.date);
                            return itemDate.year == selectedDate.year &&
                                itemDate.month == selectedDate.month &&
                                itemDate.day == selectedDate.day;
                          } catch (_) {
                            return false;
                          }
                        }).toList();

                  if (allAppointments.isEmpty) {
                    return Center(
                      child: Text(
                        "No appointments found",
                        style: AppTextStyles.bold_16
                            .copyWith(color: AppColors.white),
                      ),
                    );
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        "No appointments for this day",
                        style: AppTextStyles.bold_16
                            .copyWith(color: AppColors.white),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 3),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return AppointmentItemWidget(
                        time: item.time,
                        name: item.patientName ?? "Unknown",
                        id: item.patientId.toString(),
                        lastDate: item.date,
                        status: AppointmentStatus.done,
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

