import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../../../core/util/controller/timing_controller.dart';
import '../model/next_prayer_info.dart';
import 'next_prayer_card.dart';

/// Ponte entre os Blocs já existentes no app (TimingBloc, que por trás
/// já usa LocationBloc + a API de horários; e TimeFormatBloc, para a
/// preferência 12h/24h) e o widget puramente visual [NextPrayerCard].
///
/// Toda a lógica de Bloc e o Timer.periodic (que atualiza a contagem
/// regressiva a cada minuto) ficam isolados aqui — [NextPrayerCard] em
/// si não sabe nada sobre Bloc, Timer, GPS ou cálculo de horários.
///
/// Importante: diferente da primeira versão, este container agora trata
/// TODOS os estados do TimingBloc (não só TimingLoaded). Antes, quando o
/// TimingBloc ficava em TimingInitial/TimingFailed (ex: permissão de
/// localização negada, GPS indisponível, sem internet), o widget
/// simplesmente desaparecia (SizedBox.shrink()) sem nenhum aviso — o
/// mesmo problema que já existia em kiblat_card.dart e
/// upcoming_prayer_text.dart. Agora ele sempre mostra algo visível.
class NextPrayerCardContainer extends StatefulWidget {
  const NextPrayerCardContainer({super.key});

  @override
  State<NextPrayerCardContainer> createState() =>
      _NextPrayerCardContainerState();
}

class _NextPrayerCardContainerState extends State<NextPrayerCardContainer> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Recalcula e redesenha a cada minuto para manter o texto de
    // contagem regressiva sempre preciso, sem depender de nenhum
    // evento externo (Bloc só emite quando os horários mudam de dia).
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatDuration(AppLocalizations l10n, Duration duration) {
    if (duration.isNegative) return l10n.durationZeroMinutes;
    if (duration.inMinutes < 1) return l10n.durationLessThanMinute;

    if (duration.inMinutes < 60) {
      return l10n.minutesCount(duration.inMinutes);
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (minutes == 0) {
      return l10n.hoursCount(hours);
    }

    return '${l10n.hoursCount(hours)} ${l10n.minutesCount(minutes)}';
  }

  /// Redispara a busca de localização + horários, do mesmo jeito que
  /// tab_scaffold.dart faz no início. Usado pelo botão "Tentar novamente".
  void _retry(BuildContext context) {
    context.read<LocationBloc>().add(InitLocation());

    final prayerConfig = context.read<PrayerTimeConfigBloc>().state;
    context.read<TimingBloc>().add(
          RequestTiming(
            context.read<NotificationBloc>().state.status,
            context.read<LocationBloc>().state,
            prayerConfig.method.id,
            prayerConfig.school.id,
            prayerConfig.dayOffset,
            prayerConfig.hijriAdjustmentDays,
          ),
        );
  }

  Widget _placeholderCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2B26),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TimingBloc, TimingState>(
      builder: (context, timingState) {
        if (timingState is TimingInitial || timingState is TimingLoading) {
          return _placeholderCard(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  l10n.nextPrayerCardTitle,
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
              ],
            ),
          );
        }

        if (timingState is TimingFailed) {
          return _placeholderCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.nextPrayerUnavailable,
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 32.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                    onPressed: () => _retry(context),
                    child: Text(l10n.retry, style: TextStyle(fontSize: 12.sp)),
                  ),
                ),
              ],
            ),
          );
        }

        final loaded = timingState as TimingLoaded;
        final next = computeNextPrayer(loaded.timing.data.timings);
        if (next == null) {
          return _placeholderCard(
            child: Text(
              l10n.nextPrayerUnavailable,
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
          );
        }

        return BlocBuilder<TimeFormatBloc, TimeFormatState>(
          builder: (context, timeFormatState) {
            final formattedTime = timeFormatState.is24
                ? next.rawTime
                : convertTimeTo12HourFormat(next.rawTime);

            final countdownText = l10n.nextPrayerCountdown(
              next.name.rawKey,
              _formatDuration(l10n, next.remaining),
            );

            return NextPrayerCard(
              prayerName: next.name,
              formattedTime: formattedTime,
              countdownText: countdownText,
              title: l10n.nextPrayerCardTitle,
            );
          },
        );
      },
    );
  }
}
