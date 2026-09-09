package com.example.insulog

import android.Manifest
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "insulog/alarm"
    private var alarmPermissionFlowStarted = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "ensurePermissions" -> ensurePermissions(result)
                    "scheduleAlarm" -> scheduleAlarm(call.arguments, result)
                    "cancelAlarm" -> cancelAlarm(call.arguments, result)
                    "syncAlarms" -> syncAlarms(call.arguments, result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun ensurePermissions(result: MethodChannel.Result) {
        alarmPermissionFlowStarted = true
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 2001)
            result.success(false)
            return
        }

        if (requestExactAlarmAccessIfNeeded()) {
            result.success(false)
            return
        }
        result.success(!requestFullScreenAccessIfNeeded())
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 2001 && grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) {
            if (!requestExactAlarmAccessIfNeeded()) {
                requestFullScreenAccessIfNeeded()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        AlarmScheduler(applicationContext).rescheduleStored()
        if (alarmPermissionFlowStarted && AlarmScheduler(applicationContext).canScheduleExactAlarms()) {
            requestFullScreenAccessIfNeeded()
        }
    }

    private fun requestExactAlarmAccessIfNeeded(): Boolean {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarmManager.canScheduleExactAlarms()) {
            return false
        }
        startActivity(
            Intent(
                Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                Uri.parse("package:$packageName")
            )
        )
        return true
    }

    private fun requestFullScreenAccessIfNeeded(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return false
        val notificationManager = getSystemService(NotificationManager::class.java)
        if (notificationManager.canUseFullScreenIntent()) return false

        val preferences = getSharedPreferences("insulog_alarm_permissions", Context.MODE_PRIVATE)
        if (preferences.getBoolean("full_screen_permission_requested", false)) return false
        preferences.edit().putBoolean("full_screen_permission_requested", true).apply()
        startActivity(
            Intent(
                Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                Uri.parse("package:$packageName")
            )
        )
        return true
    }

    private fun scheduleAlarm(arguments: Any?, result: MethodChannel.Result) {
        runCatching {
            val map = arguments as? Map<*, *> ?: error("Dados do alarme ausentes.")
            AlarmScheduler(applicationContext).schedule(AlarmData.fromMap(map))
        }.onSuccess(result::success).onFailure {
            result.error("INVALID_ALARM", it.message, null)
        }
    }

    private fun cancelAlarm(arguments: Any?, result: MethodChannel.Result) {
        runCatching {
            val map = arguments as? Map<*, *> ?: error("ID do alarme ausente.")
            val id = (map["id"] as? Number)?.toInt() ?: error("ID do alarme ausente.")
            AlarmScheduler(applicationContext).cancel(id)
            true
        }.onSuccess(result::success).onFailure {
            result.error("INVALID_ALARM", it.message, null)
        }
    }

    private fun syncAlarms(arguments: Any?, result: MethodChannel.Result) {
        runCatching {
            val list = arguments as? List<*> ?: error("Lista de alarmes ausente.")
            val alarms = list.map {
                AlarmData.fromMap(it as? Map<*, *> ?: error("Alarme invalido."))
            }
            AlarmScheduler(applicationContext).sync(alarms)
        }.onSuccess(result::success).onFailure {
            result.error("INVALID_ALARM", it.message, null)
        }
    }

}
