package com.voicebubble.app

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class OverlayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "voicebubble/overlay")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }
    
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "checkPermission" -> {
                result.success(checkOverlayPermission())
            }
            "requestPermission" -> {
                requestOverlayPermission()
                result.success(null)
            }
            "showOverlay" -> {
                if (checkOverlayPermission()) {
                    context?.let { OverlayService.start(it) }
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
            "hideOverlay" -> {
                context?.let { OverlayService.stop(it) }
                result.success(true)
            }
            "isActive" -> {
                // Check if service is running
                result.success(false) // TODO: Implement proper check
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(context)
        } else {
            true
        }
    }
    
    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(context)) {
                val intent = Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:${context?.packageName}")
                )
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                activity?.startActivity(intent)
            }
        }
    }
    
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }
    
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }
    
    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }
    
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }
    
    override fun onDetachedFromActivity() {
        activity = null
    }
}

