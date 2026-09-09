package com.example.insulog

import org.json.JSONArray
import org.json.JSONObject

data class AlarmData(
    val id: Int,
    val hour: Int,
    val minute: Int,
    val days: List<String>,
    val active: Boolean,
    val sound: Boolean,
    val vibration: Boolean,
    val title: String
) {
    fun toJson(): JSONObject = JSONObject().apply {
        put("id", id)
        put("hour", hour)
        put("minute", minute)
        put("days", JSONArray(days))
        put("active", active)
        put("sound", sound)
        put("vibration", vibration)
        put("title", title)
    }

    companion object {
        private val validDays = setOf("SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM")

        fun fromMap(arguments: Map<*, *>): AlarmData {
            val id = (arguments["id"] as? Number)?.toInt() ?: error("ID do alarme ausente.")
            val hour = (arguments["hour"] as? Number)?.toInt() ?: error("Hora ausente.")
            val minute = (arguments["minute"] as? Number)?.toInt() ?: error("Minuto ausente.")
            require(id > 0) { "ID do alarme invalido." }
            require(hour in 0..23) { "Hora do alarme invalida." }
            require(minute in 0..59) { "Minuto do alarme invalido." }

            val days = (arguments["days"] as? List<*>)
                .orEmpty()
                .map { it.toString().trim().uppercase() }
                .filter(validDays::contains)
                .distinct()

            return AlarmData(
                id = id,
                hour = hour,
                minute = minute,
                days = days,
                active = arguments["active"] as? Boolean ?: true,
                sound = arguments["sound"] as? Boolean ?: true,
                vibration = arguments["vibration"] as? Boolean ?: true,
                title = arguments["title"]?.toString()?.takeIf(String::isNotBlank)
                    ?: "Lembrete do Insulog"
            )
        }

        fun fromJson(json: JSONObject): AlarmData {
            val daysJson = json.optJSONArray("days") ?: JSONArray()
            val days = buildList {
                for (index in 0 until daysJson.length()) {
                    add(daysJson.optString(index))
                }
            }
            return AlarmData(
                id = json.getInt("id"),
                hour = json.getInt("hour"),
                minute = json.getInt("minute"),
                days = days,
                active = json.optBoolean("active", true),
                sound = json.optBoolean("sound", true),
                vibration = json.optBoolean("vibration", true),
                title = json.optString("title", "Lembrete do Insulog")
            )
        }
    }
}
