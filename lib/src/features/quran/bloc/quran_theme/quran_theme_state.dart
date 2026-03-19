part of 'quran_theme_bloc.dart';

class QuranThemeState extends Equatable {
  final String quranType;
  final bool showTranslation;
  final String translationMode;
  final bool withArabs;
  final double quranFontSize;
  final double translationFontSize;
  final String quranFontFamily;
  final String translationFontFamily;
  final String qcfScrollDirection;

  QuranThemeState({
    required this.quranType,
    required this.showTranslation,
    required this.translationMode,
    required this.withArabs,
    required this.quranFontSize,
    required this.translationFontSize,
    required this.quranFontFamily,
    required this.translationFontFamily,
    required this.qcfScrollDirection,
  });

  @override
  List<Object> get props => [
        quranType,
        showTranslation,
        translationMode,
        withArabs,
        quranFontSize,
        translationFontSize,
        quranFontFamily,
        translationFontFamily,
        qcfScrollDirection,
      ];
}
