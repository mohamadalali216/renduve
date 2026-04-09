import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/logic/them_bloc/them_bloc.dart';
import 'package:randevu_app/logic/them_bloc/them_state.dart';
import 'package:randevu_app/presentation/screen/fappointment.dart';
import 'package:randevu_app/presentation/screen/searchresult.dart';
// استورد شاشة اللوجين

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return BlocProvider(
  create: (_) => ThemeBloc(),
  child: BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: state.themeData,
        home: const   SearchResultScreen(),
      );
    },
  ),
);


  }
}
