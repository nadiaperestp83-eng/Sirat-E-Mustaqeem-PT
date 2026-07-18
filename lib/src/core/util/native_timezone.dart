import 'dart:developer';

import 'package:flutter/services.dart';

/// Obtém o fuso horário IANA atual do dispositivo (ex: "America/Sao_Paulo")
/// através de um canal de plataforma nativo (MethodChannel), sem depender de
/// nenhum pacote pub externo (substitui o antigo `flutter_timezone`).
///
/// O handler correspondente deve existir em:
/// - Android: MainActivity.kt (configureFlutterEngine)
/// - iOS: AppDelegate.swift (application:didFinishLaunchingWithOptions:)
class NativeTimezone {
  NativeTimezone._();

  // Deve ser o mesmo valor usado em MainActivity.kt e AppDelegate.swift.
  static const MethodChannel _channel =
      MethodChannel('com.devtechnologies.siratemustaqeem/timezone');

  /// Retorna o identificador IANA do fuso horário do dispositivo.
  /// Em caso de falha (plataforma não suportada, canal indisponível, etc.),
  /// registra o erro e retorna 'UTC' como valor seguro de fallback.
  static Future<String> getLocalTimezone() async {
    try {
      final String? timezoneName =
          await _channel.invokeMethod<String>('getTimeZoneName');

      if (timezoneName == null || timezoneName.isEmpty) {
        return 'UTC';
      }

      return timezoneName;
    } catch (error, stackTrace) {
      log(
        'Falha ao obter o fuso horário nativo do dispositivo. '
        'Usando UTC como fallback.',
        error: error,
        stackTrace: stackTrace,
        name: 'NativeTimezone',
      );
      return 'UTC';
    }
  }
}
