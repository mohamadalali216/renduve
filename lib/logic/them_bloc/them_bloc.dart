
import 'package:randevu_app/core/them/app_them.dart';
import 'package:randevu_app/logic/them_bloc/them_state.dart';
import 'package:randevu_app/logic/them_bloc/them_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
          ThemeState(
            themeData: AppTheme.appTheme, // ثيم واحد فقط
          ),
        ) {
    on<ThemeEvent>((event, emit) {
      // معالج الأحداث
    });
  }
}
