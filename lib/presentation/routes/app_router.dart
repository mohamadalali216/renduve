import 'package:flutter/material.dart';

import 'package:randevu_app/presentation/screen/newpaitent.dart';
import 'package:randevu_app/presentation/screen/appointmentapp.dart';
import 'package:randevu_app/presentation/screen/appointmentlist.dart';
import 'package:randevu_app/presentation/screen/appointmenttake.dart';
import 'package:randevu_app/presentation/screen/fappointment.dart';
import 'package:randevu_app/presentation/screen/searchresult.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
 case AppRoutes.newPaitent:
  final doctorId = settings.arguments as int?;

  if (doctorId == null) {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text("No doctor selected"),
        ),
      ),
    );
  }

  return MaterialPageRoute(
    builder: (_) => NewPatientScreen(
      doctorId: doctorId,
    ),
  );
      case AppRoutes.appointmentapp:
        return MaterialPageRoute(
          builder: (_) => const AppointmentScreen(),
        );

   case AppRoutes.appointmentlist:
  final doctorId = settings.arguments as int?;

  return MaterialPageRoute(
    builder: (_) => AppointmentsListScreen(
      doctorId: doctorId ! ,
    ),
  );
      case AppRoutes.appointmenttake:
  return MaterialPageRoute(
    builder: (_) => const AddAppointmentScreen(),
  );

 case AppRoutes.fAppointment:
  final args = settings.arguments as Map<String, dynamic>;

  return MaterialPageRoute(
    builder: (_) => FinishAppointmentScreen(
      doctorId: args['doctorId'] as int?,
      patientId: args['patientId'] as int?,
      date: args['date'] as String,
      time: args['time'] as String,
      notes: args['notes'] as String,
    ),
  );

      case AppRoutes.searchresult:
        return MaterialPageRoute(
          builder: (_) => const SearchResultScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
        );
    }
  }

  static Future<dynamic> navigateTo(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  return Navigator.pushNamed(
    context,
    routeName,
    arguments: arguments,
  );
}

  static Future<dynamic> replaceWith(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}