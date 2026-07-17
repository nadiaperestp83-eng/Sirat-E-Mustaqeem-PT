import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/app_localizations.dart';
import 'routes/routes.dart';
import 'src/core/notification/notification_service.dart';
import 'src/core/util/bloc/allah_names/allah_name_bloc.dart';
import 'src/core/util/bloc/database/database_bloc.dart';
import 'src/core/util/bloc/dua/dua_bloc.dart';
import 'src/core/util/bloc/juz/juz_bloc.dart';
import 'src/core/util/bloc/language/language_bloc.dart';
import 'src/core/util/bloc/location/location_bloc.dart';
import 'src/core/util/bloc/notification/notification_bloc.dart';
import 'src/core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import 'src/core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import 'src/core/util/bloc/quran/quran_bloc.dart';
import 'src/core/util/bloc/quran_audio/quran_audio_bloc.dart';
import 'src/core/util/bloc/surah/surah_bloc.dart';
import 'src/core/util/bloc/tasbih/tasbih_bloc.dart';
import 'src/core/util/bloc/theme/theme_bloc.dart';
import 'src/core/util/bloc/time_format/time_format_bloc.dart';
import 'src/features/bottom_tab/bloc/tab/tab_bloc.dart';
import 'src/features/quran/bloc/quran_theme/quran_theme_bloc.dart';
import 'src/features/splash/screen/splash_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Mapeia o idioma do app para o modo de tradução do Alcorão.
/// pt -> Português (Samir El Hayek, via pacote `quran`)
/// en -> mantém a tradução padrão já usada pelo app
String _translationModeForLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'pt':
      return 'Portuguese';
    default:
      return 'English (Clear Quran)';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await NotificationService().init();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => TimeFormatBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider(
          create: (context) => QuranThemeBloc(),
        ),
        BlocProvider(
          create: (context) => TimingBloc(),
        ),
        BlocProvider(
          create: (context) => PrayerTimeConfigBloc(),
        ),
        BlocProvider(
          create: (context) => AllahNameBloc(),
        ),
        BlocProvider(
          create: (context) => DuaBloc(),
        ),
        BlocProvider(
          create: (context) => QuranBloc(),
        ),
        BlocProvider(
          create: (context) => QuranAudioBloc(),
        ),
        BlocProvider(
          create: (context) => SurahBloc(),
        ),
        BlocProvider(
          create: (context) => TasbihBloc(),
        ),
        BlocProvider(
          create: (context) => JuzBloc(),
        ),
        BlocProvider(
          create: (context) => DatabaseBloc(),
        ),
        BlocProvider(
          create: (context) => TabBloc(),
        ),
        BlocProvider(
          create: (context) => LocationBloc(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(414, 896),
        builder: (context, child) {
          // Sempre que o idioma do app mudar (tela de Configurações),
          // ajusta automaticamente a tradução do Alcorão exibida.
          return BlocListener<LanguageBloc, LanguageState>(
            listener: (context, languageState) {
              context.read<QuranThemeBloc>().add(
                    SwitchTranslationMode(
                      _translationModeForLocale(languageState.locale),
                    ),
                  );
            },
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, languageState) {
                    return MaterialApp(
                      title: 'Sirate Mustaqeem',
                      debugShowCheckedModeBanner: false,
                      color: Colors.white,
                      theme: themeState.currentTheme,
                      navigatorKey: appNavigatorKey,
                      locale: languageState.locale,
                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      home: const SplashScreen(),
                      onGenerateRoute: RouteGenerator.generateRoute,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
