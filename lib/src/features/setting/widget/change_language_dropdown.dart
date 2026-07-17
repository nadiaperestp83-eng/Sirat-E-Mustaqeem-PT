import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/util/bloc/language/language_bloc.dart';

class ChangeLanguageDropdown extends StatelessWidget {
  const ChangeLanguageDropdown();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return SizedBox(
          width: 160.w,
          child: DropdownButtonFormField<String>(
            initialValue: state.locale.languageCode,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(l10n.languageEnglish),
              ),
              DropdownMenuItem(
                value: 'pt',
                child: Text(l10n.languagePortuguese),
              ),
            ],
            onChanged: (code) {
              if (code == null) return;
              context.read<LanguageBloc>().add(ChangeLanguage(Locale(code)));
            },
          ),
        );
      },
    );
  }
}
