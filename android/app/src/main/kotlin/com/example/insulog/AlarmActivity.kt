package com.example.insulog

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import java.util.Locale

class AlarmActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }

        val title = intent.getStringExtra(EXTRA_TITLE) ?: "Lembrete do Insulog"
        val hour = intent.getIntExtra(EXTRA_HOUR, 0)
        val minute = intent.getIntExtra(EXTRA_MINUTE, 0)

        val content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(48, 48, 48, 48)
            setBackgroundColor(Color.rgb(242, 242, 242))
        }
        content.addView(TextView(this).apply {
            text = title
            textSize = 26f
            gravity = Gravity.CENTER
            setTextColor(Color.rgb(23, 23, 23))
        })
        content.addView(TextView(this).apply {
            text = String.format(Locale.getDefault(), "%02d:%02d", hour, minute)
            textSize = 64f
            gravity = Gravity.CENTER
            setTextColor(Color.rgb(62, 167, 95))
            setPadding(0, 28, 0, 48)
        })
        content.addView(Button(this).apply {
            text = "Desligar"
            textSize = 20f
            setOnClickListener {
                startService(Intent(this@AlarmActivity, AlarmService::class.java).apply {
                    action = AlarmService.ACTION_STOP
                })
                finishAndRemoveTask()
            }
        }, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))
        setContentView(content)
    }

    companion object {
        private const val EXTRA_TITLE = "alarm_title"
        private const val EXTRA_HOUR = "alarm_hour"
        private const val EXTRA_MINUTE = "alarm_minute"

        fun intent(context: Context, alarm: AlarmData): Intent {
            return Intent(context, AlarmActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra(EXTRA_TITLE, alarm.title)
                putExtra(EXTRA_HOUR, alarm.hour)
                putExtra(EXTRA_MINUTE, alarm.minute)
            }
        }
    }
}
