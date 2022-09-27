package app.krispcall

import com.flutter.twilio.voice.TwilioVoice.Companion.registerWith
import io.flutter.plugin.common.PluginRegistry

object WorkManagerPluginRegistrant {
    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        registerWith(registry.registrarFor("be.tramckrijte.workmanager.WorkmanagerPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = WorkManagerPluginRegistrant::class.java.canonicalName
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
}