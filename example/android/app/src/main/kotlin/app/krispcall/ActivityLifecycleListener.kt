package app.krispcall

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import com.flutter.twilio.voice.TwilioVoice

object ActivityLifecycleListener : Application.ActivityLifecycleCallbacks {

    var isActivityRunning = false
    var listener: Listener? = null
    private const val TAG = "LifecycleCallbacks"

    override fun onActivityPaused(p0: Activity) {
        Log.d(TAG, "onActivityPaused at ${p0.localClassName}")
    }

    override fun onActivityStarted(p0: Activity) {
        Log.d(TAG, "onActivityStarted at ${p0.localClassName}")
    }

    override fun onActivityDestroyed(p0: Activity) {
        Log.d(TAG, "onActivityDestroyed at ${p0.localClassName}")
        try {
            TwilioVoice.instance.disConnect()
            TwilioVoice.instance.disConnect()
            Log.d(TAG, "onActivityDestroyed at destroyed")

            val SHARED_PREFERENCES_NAME = "FlutterSharedPreferences"
            val incoming = "flutter.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS"
            val outgoing = "flutter.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS"
            val prefs = app.krispcall.Application.context.getSharedPreferences(
                SHARED_PREFERENCES_NAME,
                Context.MODE_PRIVATE
            )
            prefs.edit().putBoolean(incoming, false).apply()
            prefs.edit().putBoolean(outgoing, false).apply()

            isActivityRunning = false
            listener?.onFlutterActivityDestroyed()
        } catch (e: Exception) {

        }
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
        Log.d(TAG, "onActivitySaveInstanceState at ${p0.localClassName}")
    }

    override fun onActivityStopped(p0: Activity) {
        Log.d(TAG, "onActivityStopped at ${p0.localClassName}")
    }

    override fun onActivityCreated(p0: Activity, p1: Bundle?) {
        Log.d(TAG, "onActivityCreated at ${p0.localClassName}")

        if (p0 is MainActivity) {
            isActivityRunning = true
            listener?.onFlutterActivityCreated()
        }
    }

    override fun onActivityResumed(p0: Activity) {
        Log.d(TAG, "onActivityResumed at ${p0.localClassName}")
    }

    interface Listener {
        fun onFlutterActivityCreated()

        fun onFlutterActivityDestroyed()
    }
}