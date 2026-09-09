package com.example.insulog

import android.content.Context
import org.json.JSONArray

class AlarmRepository(context: Context) {
    private val preferences = context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)

    fun getAll(): List<AlarmData> {
        val json = preferences.getString(KEY_ALARMS, null) ?: return emptyList()
        return runCatching {
            val array = JSONArray(json)
            buildList {
                for (index in 0 until array.length()) {
                    add(AlarmData.fromJson(array.getJSONObject(index)))
                }
            }
        }.getOrDefault(emptyList())
    }

    fun get(id: Int): AlarmData? = getAll().firstOrNull { it.id == id }

    fun save(alarm: AlarmData) {
        val alarms = getAll().filterNot { it.id == alarm.id } + alarm
        replaceAll(alarms)
    }

    fun remove(id: Int) {
        replaceAll(getAll().filterNot { it.id == id })
    }

    fun replaceAll(alarms: List<AlarmData>) {
        val array = JSONArray()
        alarms.forEach { array.put(it.toJson()) }
        preferences.edit().putString(KEY_ALARMS, array.toString()).apply()
    }

    private companion object {
        const val PREFERENCES_NAME = "insulog_scheduled_alarms"
        const val KEY_ALARMS = "alarms"
    }
}
