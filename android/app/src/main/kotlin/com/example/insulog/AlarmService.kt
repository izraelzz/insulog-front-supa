package com.example.insulog

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.IBinder
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.app.NotificationCompat
import java.util.Locale

class AlarmService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopAlarm()
            return START_NOT_STICKY
        }

        val alarmId = intent?.getIntExtra(EXTRA_ALARM_ID, 0) ?: 0
        val title = intent?.getStringExtra(EXTRA_TITLE) ?: "Lembrete do Insulog"
        val hour = intent?.getIntExtra(EXTRA_HOUR, 0) ?: 0
        val minute = intent?.getIntExtra(EXTRA_MINUTE, 0) ?: 0
        val sound = intent?.getBooleanExtra(EXTRA_SOUND, true) ?: true
        val vibration = intent?.getBooleanExtra(EXTRA_VIBRATION, true) ?: true
        startForeground(notificationId(alarmId), buildNotification(alarmId, title, hour, minute))
        if (sound) startAlarmSound()
        if (vibration) startVibration()
        return START_NOT_STICKY
    }

    private fun buildNotification(
        alarmId: Int,
        title: String,
        hour: Int,
        minute: Int
    ): android.app.Notification {
        val alarm = AlarmRepository(this).get(alarmId) ?: AlarmData(
            alarmId, hour, minute, emptyList(), true, true, true, title
        )
        val openApp = PendingIntent.getActivity(
            this,
            alarmId,
            AlarmActivity.intent(this, alarm),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val stopAlarm = PendingIntent.getService(
            this,
            alarmId,
            Intent(this, AlarmService::class.java).apply { action = ACTION_STOP },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle(title)
            .setContentText(
                String.format(Locale.getDefault(), "%02d:%02d — toque para abrir", hour, minute)
            )
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setContentIntent(openApp)
            .setFullScreenIntent(openApp, true)
            .addAction(0, "Desligar", stopAlarm)
            .build()
    }

    private fun startAlarmSound() {
        if (mediaPlayer?.isPlaying == true) return
        val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        mediaPlayer = MediaPlayer().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
            )
            setDataSource(this@AlarmService, alarmUri)
            isLooping = true
            prepare()
            start()
        }
    }

    private fun startVibration() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
        val pattern = longArrayOf(0, 700, 300, 700, 800)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
        } else {
            @Suppress("DEPRECATION")
            vibrator?.vibrate(pattern, 0)
        }
    }

    private fun stopAlarm() {
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null
        vibrator?.cancel()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    override fun onDestroy() {
        mediaPlayer?.release()
        mediaPlayer = null
        vibrator?.cancel()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        const val ACTION_START = "com.example.insulog.START_ALARM"
        const val ACTION_STOP = "com.example.insulog.STOP_ALARM"
        const val EXTRA_ALARM_ID = "alarm_id"
        const val EXTRA_TITLE = "alarm_title"
        const val EXTRA_HOUR = "alarm_hour"
        const val EXTRA_MINUTE = "alarm_minute"
        const val EXTRA_SOUND = "alarm_sound"
        const val EXTRA_VIBRATION = "alarm_vibration"
        private const val CHANNEL_ID = "insulog_ringing_alarm"
        private const val NOTIFICATION_ID_BASE = 20_000
    }

    private fun notificationId(alarmId: Int): Int = NOTIFICATION_ID_BASE + alarmId.coerceAtLeast(0)

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Alarmes em andamento",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Alarmes ativos do Insulog"
            setSound(null, null)
            enableVibration(false)
            lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
        }
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }
}
