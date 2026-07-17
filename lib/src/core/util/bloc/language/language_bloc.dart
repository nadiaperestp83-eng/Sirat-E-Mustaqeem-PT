import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends HydratedBloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(Locale('en'))) {
    on<ChangeLanguage>((event, emit) {
      emit(LanguageState(event.locale));
    });
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    try {
      return LanguageState(Locale(json['languageCode'] as String));
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    try {
      return {
        'languageCode': state.locale.languageCode,
      };
    } catch (e) {
      return null;
    }
  }
}
