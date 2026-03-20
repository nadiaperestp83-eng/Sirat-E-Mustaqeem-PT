import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'quran_theme_event.dart';
part 'quran_theme_state.dart';

class QuranThemeBloc extends HydratedBloc<QuranThemeEvent, QuranThemeState> {
  QuranThemeBloc()
      : super(
          QuranThemeState(
            quranType: 'Normal',
            showTranslation: true,
            translationMode: 'Urdu',
            withArabs: true,
            quranFontSize: 24,
            quranFontFamily: 'Uthman',
            translationFontSize: 16,
            translationFontFamily: 'Jameel',
            qcfScrollDirection: 'Vertical',
          ),
        ) {
    on<QuranThemeEvent>((event, emit) async {
      if (event is SetQuranType) {
        emit(QuranThemeState(
          quranType: event.type,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: event.type == 'QCF' ? 'qcf' : 'Uthman',
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is ShowTranslation) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: event.show,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is SwitchTranslationMode) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: event.mode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is ShowWithArab) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: event.show,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is AddQuranFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize + 1,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is ReduceQuranFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize - 1,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is SetQuranFontFamily) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: event.family,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is AddTranslationFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize + 1,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is ReduceTranslationFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize - 1,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is SetTranslationFontFamily) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: event.family,
          qcfScrollDirection: state.qcfScrollDirection,
        ));
      }
      if (event is SetQcfScrollDirection) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          withArabs: state.withArabs,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: event.direction,
        ));
      }
    });
  }

  Stream<QuranThemeState> mapEventToState(
    QuranThemeEvent event,
  ) async* {}

  @override
  QuranThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return QuranThemeState(
        quranType: json['quranType']?.toString() ?? 'Normal',
        showTranslation: json['showTranslation'] as bool,
        translationMode: json['translationMode'].toString(),
        withArabs: json['withArabs'] as bool,
        quranFontSize: json['quranFontSize'] as double,
        quranFontFamily: json['quranFontFamily'].toString(),
        translationFontSize: json['translationFontSize'] as double,
        translationFontFamily: json['translationFontFamily'].toString(),
        qcfScrollDirection:
            json['qcfScrollDirection']?.toString() ?? 'Vertical',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(QuranThemeState state) {
    try {
      return {
        'showTranslation': state.showTranslation,
        'quranType': state.quranType,
        'translationMode': state.translationMode,
        'withArabs': state.withArabs,
        'quranFontSize': state.quranFontSize,
        'quranFontFamily': state.quranFontFamily,
        'translationFontSize': state.translationFontSize,
        'translationFontFamily': state.translationFontFamily,
        'qcfScrollDirection': state.qcfScrollDirection,
      };
    } catch (e) {
      return null;
    }
  }
}
