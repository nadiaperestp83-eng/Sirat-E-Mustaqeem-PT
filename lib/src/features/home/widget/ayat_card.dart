import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        Theme,
        Colors,
        BorderRadius,
        BoxDecoration,
        Divider,
        LinearGradient,
        Localizations;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran.dart';

import '../../../../l10n/app_localizations.dart';
import '../../utils/sirat_card.dart';

class AyatCard extends StatelessWidget {
  AyatCard({super.key});
  final RandomVerse randomVerse = RandomVerse();

  /// A tradução embutida no pacote `quran` (randomVerse.translation) vem
  /// sempre em inglês. Como o app já usa `quran.Translation.portuguese`
  /// (Samir El Hayek) na leitura principal do Alcorão, buscamos a mesma
  /// tradução aqui quando o idioma atual do app for português.
  String _translationFor(BuildContext context) {
    final isPortuguese =
        Localizations.localeOf(context).languageCode == 'pt';

    if (!isPortuguese) {
      return randomVerse.translation;
    }

    try {
      return quran.getVerseTranslation(
        randomVerse.surahNumber,
        randomVerse.verseNumber,
        translation: quran.Translation.portuguese,
      );
    } catch (_) {
      return randomVerse.translation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SiratCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  CupertinoIcons.book,
                  color: primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                l10n.quranAyatOfTheDay,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withValues(alpha: 0.1),
                  primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  randomVerse.verse,
                  style: TextStyle(
                    fontFamily: GoogleFonts.zain().fontFamily,
                    fontSize: 20.sp,
                    height: 1.6,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Divider(
                  color: primaryColor.withValues(alpha: 0.3),
                  height: 1,
                ),
                SizedBox(height: 12.h),
                Text(
                  _translationFor(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.surahAyahLabel(
                    quran.getSurahName(randomVerse.surahNumber),
                    randomVerse.verseNumber,
                  ),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
