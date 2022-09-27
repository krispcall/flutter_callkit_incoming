package app.krispcall

import android.content.Context
import com.google.firebase.FirebaseApp
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain

abstract class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    companion object {
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(ActivityLifecycleListener)
        FirebaseApp.initializeApp(this)
        FlutterMain.startInitialization(this)
        context = applicationContext
    }

    override fun registerWith(registry: PluginRegistry) {
        TwilioVoicePluginRegistrant.registerWith(registry)
        SharedPreferencePluginRegistrant.registerWith(registry)
        InCallManagerPluginRegistrant.registerWith(registry)
        FlutterToastPluginRegistrant.registerWith(registry)
        AwesomeNotificationPluginRegistrant.registerWith(registry)
        WorkManagerPluginRegistrant.registerWith(registry)
    }
}

