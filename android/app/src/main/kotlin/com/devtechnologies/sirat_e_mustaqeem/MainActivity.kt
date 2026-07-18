package com.devtechnologies.siratemustaqeem

import java.util.TimeZone

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Deve ser o mesmo valor usado em NativeTimezone.dart (Dart) e AppDelegate.swift (iOS).
    private val timezoneChannelName = "com.devtechnologies.siratemustaqeem/timezone"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Canal de plataforma nativo: expõe o fuso horário IANA atual do
        // dispositivo (ex: "America/Sao_Paulo") para o lado Dart, sem
        // depender de nenhum pacote pub externo.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            timezoneChannelName
        ).setMethodCallHandler { call, result ->
            if (call.method == "getTimeZoneName") {
                result.success(TimeZone.getDefault().id)
            } else {
                result.notImplemented()
            }
        }
    }
}
