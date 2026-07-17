import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================== EVENTS ====================

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

/// Dispara no boot do app para carregar o idioma salvo no dispositivo.
class LoadSavedLanguage extends LanguageEvent {
  const LoadSavedLanguage();
}

/// Dispara quando o usuário troca o idioma na tela de Configurações.
class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  const ChangeLanguage(this.locale);

  @override
  List<Object?> get props => [locale];
}

// ==================== STATE ====================

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  /// Estado inicial: Inglês, até o SharedPreferences carregar o valor salvo.
  factory LanguageState.initial() => const LanguageState(Locale('en'));

  LanguageState copyWith({Locale? locale}) {
    return LanguageState(locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}

// ==================== BLOC ====================

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _prefsKey = 'app_language_code';

  LanguageBloc() : super(LanguageState.initial()) {
    on<LoadSavedLanguage>(_onLoadSavedLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadSavedLanguage(
    LoadSavedLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_prefsKey);

    if (savedCode != null) {
      emit(state.copyWith(locale: Locale(savedCode)));
    }
    // Se não houver nada salvo, mantém o padrão (inglês) definido em LanguageState.initial()
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, event.locale.languageCode);

    emit(state.copyWith(locale: event.locale));
  }
}
