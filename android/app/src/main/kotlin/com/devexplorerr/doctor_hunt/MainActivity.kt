package com.devexplorerr.doctor_hunt

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "doctor_hunt/speech_settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAppSettings" -> {
                        val packageName = call.argument<String>("package")
                        val opened = openAppSettings(packageName)
                        result.success(opened)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Opens the app details settings page for [packageName], falling back to
     * the general settings page if the app is not found or cannot be opened.
     *
     * Returns true when any settings page was successfully launched.
     */
    private fun openAppSettings(packageName: String?): Boolean {
        // Try the specific app's details page first.
        if (!packageName.isNullOrBlank()) {
            try {
                val intent = Intent(
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.fromParts("package", packageName, null),
                ).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
                return true
            } catch (e: ActivityNotFoundException) {
                // App not installed / not resolvable — fall through to general settings.
            }
        }

        // Fallback: general device settings.
        return try {
            val intent = Intent(Settings.ACTION_SETTINGS).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
            true
        } catch (e: ActivityNotFoundException) {
            false
        }
    }
}
