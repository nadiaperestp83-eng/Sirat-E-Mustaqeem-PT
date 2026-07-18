import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:intl/intl.dart';

/// function to get today's date
/// [localeName] segue o idioma atual do app (ex: 'en', 'pt') para exibir
/// o mês e demais textos no idioma correto. Se omitido, usa o locale
/// padrão do dispositivo/pacote intl.
String getTodayDate({String? localeName}) {
  return DateFormat.yMMMMd(localeName).format(
    DateTime.now(),
  );
}

/// function to get the islamic date,
String getIslamicDate({int adjustmentDays = 0}) {
  try {
    final date = DateTime.now().add(Duration(days: adjustmentDays));
    return HijriCalendarConfig.fromGregorian(date).toFormat("dd MMMM, yyyy");
  } catch (_) {
    return HijriCalendarConfig.now().toFormat("dd MMMM, yyyy");
  }
}
