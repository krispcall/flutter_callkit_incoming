package app.krispcall

import com.flutter.twilio.voice.TwilioVoice.Companion.registerWith
import io.flutter.plugin.common.PluginRegistry

object TwilioVoicePluginRegistrant {
    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        registerWith(registry.registrarFor("com.flutter.twilio.voice"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = TwilioVoicePluginRegistrant::class.java.canonicalName
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
}