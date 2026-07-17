import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/util/bloc/language/language_bloc.dart';

/// Idiomas suportados pelo app.
/// Para adicionar um novo idioma, basta incluir o código aqui e criar o
/// respectivo app_<code>.arb em lib/l10n/.
const List<String> kSupportedLanguageCodes = ['en', 'pt'];

/// Retorna o nome de exibição do idioma a partir do AppLocalizations,
/// já traduzido para o idioma atualmente selecionado.
String languageDisplayName(AppLocalizations l10n, String code) {
  switch (code) {
    case 'pt':
      return l10n.languagePortuguese;
    case 'en':
    default:
      return l10n.languageEnglish;
  }
}

/// Substitui o antigo DropdownButtonFormField.
///
/// Um ListTile mostra o idioma atualmente selecionado; ao tocar, abre um
/// ModalBottomSheet (padrão Android/iOS moderno) com as opções disponíveis.
/// A troca de idioma é instantânea (via LanguageBloc) e persiste entre
/// sessões porque LanguageBloc já é um HydratedBloc.
class LanguageSelectorTile extends StatelessWidget {
  const LanguageSelectorTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        final currentCode = state.locale.languageCode;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            l10n.language,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageDisplayName(l10n, currentCode),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.6),
              ),
            ],
          ),
          onTap: () => _openLanguageSheet(context, currentCode),
        );
      },
    );
  }

  void _openLanguageSheet(BuildContext context, String currentCode) {
    // Guardamos referências ao bloc e ao AppLocalizations ANTES de abrir o
    // sheet, para não depender do `context` da tela por trás uma vez que o
    // modal já esteja aberto.
    final languageBloc = context.read<LanguageBloc>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: 8.h),
              ...kSupportedLanguageCodes.map(
                (code) => RadioListTile<String>(
                  value: code,
                  groupValue: currentCode,
                  title: Text(languageDisplayName(l10n, code)),
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (selectedCode) => _selectLanguage(
                    sheetContext,
                    languageBloc,
                    selectedCode,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  void _selectLanguage(
    BuildContext sheetContext,
    LanguageBloc languageBloc,
    String? code,
  ) {
    if (code == null) return;
    // Dispara o evento no bloc: o MaterialApp (main.dart) já escuta o
    // LanguageBloc e atualiza a `locale` do app instantaneamente. Como
    // LanguageBloc é um HydratedBloc, a escolha também é persistida
    // automaticamente em disco.
    languageBloc.add(ChangeLanguage(Locale(code)));
    Navigator.of(sheetContext).pop();
  }
}
