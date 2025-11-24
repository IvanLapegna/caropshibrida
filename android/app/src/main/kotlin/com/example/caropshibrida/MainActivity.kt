package com.example.caropshibrida

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log // Importamos la clase Log para depuración
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.caropshibrida/exact_alarms"
    private val TAG = "AlarmDebug" // Etiqueta para el registro

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "canScheduleExactAlarms" -> {
                    val can = canScheduleExactAlarms()
                    // Agregamos un log para ver el resultado en la consola
                    Log.d(TAG, "canScheduleExactAlarms() returned: $can (API ${Build.VERSION.SDK_INT})")
                    result.success(can)
                }
                "openScheduleExactAlarmSettings" -> {
                    Log.d(TAG, "Opening exact alarm settings...")
                    openScheduleExactAlarmSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun canScheduleExactAlarms(): Boolean {
        // En versiones anteriores a API 31 (Android S) no existe la comprobación -> asumimos true
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true

        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        return alarmManager.canScheduleExactAlarms()
    }

    private fun openScheduleExactAlarmSettings() {
        val packageName = applicationContext.packageName
        Log.d(TAG, "Package Name: $packageName")

        // Intent recomendado (API 31+)
        try {
            val intent = Intent("android.settings.REQUEST_SCHEDULE_EXACT_ALARM")
            intent.data = android.net.Uri.parse("package:$packageName")
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
            Log.d(TAG, "Attempted to open REQUEST_SCHEDULE_EXACT_ALARM (Recommended)")
            return
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open REQUEST_SCHEDULE_EXACT_ALARM: ${e.message}")
            // fallback más abajo
        }

        // Fallback: detalles de la app
        try {
            val fallback = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            fallback.data = android.net.Uri.parse("package:$packageName")
            fallback.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(fallback)
            Log.d(TAG, "Attempted to open ACTION_APPLICATION_DETAILS_SETTINGS (Fallback 1)")
            return
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open ACTION_APPLICATION_DETAILS_SETTINGS: ${e.message}")
        }

        // Último fallback: lista de apps
        val fallback2 = Intent(android.provider.Settings.ACTION_MANAGE_ALL_APPLICATIONS_SETTINGS)
        fallback2.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(fallback2)
        Log.d(TAG, "Attempted to open ACTION_MANAGE_ALL_APPLICATIONS_SETTINGS (Fallback 2)")
    }
}