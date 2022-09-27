package app.krispcall

import io.flutter.plugin.common.PluginRegistry

object InCallManagerPluginRegistrant {
    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        com.cloudwebrtc.flutterincallmanager.FlutterIncallManagerPlugin.registerWith(registry.registrarFor("com.cloudwebrtc.flutterincallmanager.FlutterIncallManagerPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = InCallManagerPluginRegistrant::class.java.canonicalName
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
}