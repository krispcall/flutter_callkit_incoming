package app.krispcall

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val intent = Intent(
                applicationContext,
                ClosingService::class.java
            )
            startService(intent)

        } catch (e: Exception) {
            Log.d("this===error-main",e.toString())
        }
    }
}
