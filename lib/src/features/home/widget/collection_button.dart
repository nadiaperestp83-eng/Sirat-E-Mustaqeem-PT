import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Theme, Colors, BorderRadius, BoxDecoration, showDialog;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../l10n/app_localizations.dart';
import '../../utils/coming_soon_dialog.dart';
import '../model/collection.dart';

/// Resolve a chave de título (CollectionTitleKey) para o texto localizado
/// correspondente, usando o AppLocalizations do idioma atual.
String collectionTitleText(AppLocalizations l10n, CollectionTitleKey key) {
  switch (key) {
    case CollectionTitleKey.quran:
      return l10n.quran;
    case CollectionTitleKey.hadees:
      return l10n.hadith;
    case CollectionTitleKey.dua:
      return l10n.collectionDua;
    case CollectionTitleKey.tasbih:
      return l10n.collectionTasbih;
    case CollectionTitleKey.azkars:
      return l10n.azkar;
    case CollectionTitleKey.allahNames:
      return l10n.collectionAllahNames;
    case CollectionTitleKey.prayerTimes:
      return l10n.prayerTimes;
    case CollectionTitleKey.qiblaDirection:
      return l10n.collectionQiblaDirection;
    case CollectionTitleKey.liveTv:
      return l10n.collectionLiveTv;
    case CollectionTitleKey.others:
      return l10n.collectionOthers;
  }
}

class CollectionButton extends StatelessWidget {
  const CollectionButton(this.collection, {super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () {
        if (collection.routeName == 'Coming Soon') {
          showDialog(
            context: context,
            builder: (context) => ComingSoonDialog(),
          );
          return;
        }
        if (collection.routeName != '') {
          Navigator.of(context).pushNamed(collection.routeName);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              collection.assetName,
              width: 64.w,
            ),
            SizedBox(height: 6.h),
            Text(
              collectionTitleText(l10n, collection.titleKey),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
