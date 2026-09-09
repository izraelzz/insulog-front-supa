package com.example.insulog

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class AlarmRestoreReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val pendingResult = goAsync()
        try {
            AlarmScheduler(context.applicationContext).rescheduleStored()
        } finally {
            pendingResult.finish()
        }
    }
}
