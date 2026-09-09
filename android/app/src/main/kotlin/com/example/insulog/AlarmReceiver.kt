package com.example.insulog

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val alarmId = intent.getIntExtra(AlarmScheduler.EXTRA_ALARM_ID, 0)
        val alarm = AlarmRepository(context).get(alarmId) ?: return
        AlarmScheduler(context.applicationContext).scheduleNextAfterTrigger(alarmId)

        val serviceIntent = Intent(context, AlarmService::class.java).apply {
            action = AlarmService.ACTION_START
            putExtra(AlarmService.EXTRA_ALARM_ID, alarm.id)
            putExtra(AlarmService.EXTRA_TITLE, alarm.title)
            putExtra(AlarmService.EXTRA_HOUR, alarm.hour)
            putExtra(AlarmService.EXTRA_MINUTE, alarm.minute)
            putExtra(AlarmService.EXTRA_SOUND, alarm.sound)
            putExtra(AlarmService.EXTRA_VIBRATION, alarm.vibration)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }
}
