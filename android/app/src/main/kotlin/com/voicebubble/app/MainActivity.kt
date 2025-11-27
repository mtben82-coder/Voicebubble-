package com.voicebubble.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "voicebubble/overlay"
    private val TAG = "MainActivity"
    
    private val overlayReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "SHOW_FLUTTER_OVERLAY") {
                Log.d(TAG, "Received SHOW_FLUTTER_OVERLAY broadcast")
                showFlutterOverlay()
            }
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register custom overlay plugin
        flutterEngine.plugins.add(OverlayPlugin())
        
        // Setup method channel for overlay control
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showFlutterOverlay" -> {
                    Log.d(TAG, "Showing Flutter overlay window via method channel")
                    showFlutterOverlay()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Register broadcast receiver for overlay trigger
        val filter = IntentFilter("SHOW_FLUTTER_OVERLAY")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(overlayReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(overlayReceiver, filter)
        }
        
        Log.d(TAG, "MainActivity created and broadcast receiver registered")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(overlayReceiver)
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering receiver", e)
        }
    }
    
    private fun showFlutterOverlay() {
        Log.d(TAG, "Triggering Flutter overlay display")
        flutterEngine?.let { engine ->
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(
                "triggerOverlay",
                null
            )
        }
    }
}
