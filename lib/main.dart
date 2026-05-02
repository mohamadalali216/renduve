import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/logic/them_bloc/them_bloc.dart';
import 'package:randevu_app/logic/them_bloc/them_state.dart';
import 'package:randevu_app/presentation/routes/app_router.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';

import 'package:randevu_app/logic/paitent_bloc/paitent_bloc.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_bloc.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_bloc.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_event.dart';

import 'package:randevu_app/data/repository/paitent_repository.dart';
import 'package:randevu_app/data/repository/appointment_repository.dart';
import 'package:randevu_app/data/repository/doctor_repository.dart';

import 'package:randevu_app/data/datasources/local/paitent_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/paitent_remote_datasource.dart';

import 'package:randevu_app/data/datasources/local/appointment_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/appointment_remot_datasource.dart';

import 'package:randevu_app/data/datasources/local/doctor_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/doctor_remote_datasource.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// ✅ Navigator Observer لتتبع الـ navigation
class _MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('🔥 NAVIGATOR: PUSH - Current: ${route.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('🔥 NAVIGATOR: POP - Removed: ${route.settings.name}, Back to: ${previousRoute?.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print('🔥 NAVIGATOR: REMOVE - Removed: ${route.settings.name}');
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('🔥 NAVIGATOR: REPLACE - Old: ${oldRoute?.settings.name}, New: ${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// ================= REPOSITORIES =================
        RepositoryProvider<PatientRepository>(
          create: (context) => PatientRepository(
            localDataSource: PatientLocalDataSource(),
            remoteDataSource: PatientRemoteDataSource(),
          ),
        ),

        RepositoryProvider<AppointmentRepository>(
          create: (context) => AppointmentRepository(
            localDataSource: AppointmentLocalDataSource(),
            remoteDataSource: AppointmentRemoteDataSource(),
          ),
        ),

        /// 🔥 DOCTOR REPOSITORY
        RepositoryProvider<DoctorRepository>(
          create: (context) => DoctorRepository(
            localDataSource: DoctorLocalDataSource(),
            remoteDataSource: DoctorRemoteDataSource(),
          ),
        ),
      ],

      child: MultiBlocProvider(
        providers: [
          /// ================= PATIENT =================
          BlocProvider<PatientBloc>(
            create: (context) => PatientBloc(
              patientRepository: context.read<PatientRepository>(),
              appointmentRepository: context.read<AppointmentRepository>(),
            ),
          ),

          /// ================= APPOINTMENT =================
          BlocProvider<AppointmentBloc>(
            create: (context) => AppointmentBloc(
              context.read<AppointmentRepository>(),
            ),
          ),

          /// 🔥 DOCTOR BLOC
          BlocProvider<DoctorBloc>(
            create: (context) => DoctorBloc(
              context.read<DoctorRepository>(),
            )..add(LoadDoctorsEvent()),
          ),

          /// ================= THEME =================
          BlocProvider<ThemeBloc>(
            create: (_) => ThemeBloc(),
          ),
        ],

        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.themeData,
              initialRoute: AppRoutes.appointmentapp,
              onGenerateRoute: AppRouter.generateRoute,
              // ✅ أضفنا Navigator Observer
              navigatorObservers: [
                _MyNavigatorObserver(),
              ],
            );
          },
        ),
      ),
    );
  }
}