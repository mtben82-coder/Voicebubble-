package com.voicebubble.app

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class OverlayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    
    private lateinit var overlayChannel: MethodChannel
    private lateinit var accessibilityChannel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        overlayChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "voicebubble/overlay")
        overlayChannel.setMethodCallHandler(this)
        
        accessibilityChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "voicebubble/accessibility")
        accessibilityChannel.setMethodCallHandler(this)
        
        context = flutterPluginBinding.applicationContext
    }
    
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            // Overlay permission methods
            "checkPermission" -> {
                result.success(checkOverlayPermission())
            }
            "requestPermission" -> {
                requestOverlayPermission()
                result.success(null)
            }
            "showOverlay" -> {
                result.success(isAccessibilityServiceEnabled())
            }
            "hideOverlay" -> {
                result.success(true)
            }
            "isActive" -> {
                result.success(isAccessibilityServiceEnabled())
            }
            // Accessibility service methods
            "isEnabled" -> {
                result.success(isAccessibilityServiceEnabled())
            }
            "openSettings" -> {
                openAccessibilitySettings()
                result.success(null)
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
    
    private fun isAccessibilityServiceEnabled(): Boolean {
        val ctx = context ?: return false
        val expectedComponentName = "${ctx.packageName}/${VoiceBubbleAccessibilityService::class.java.name}"
        
        val enabledServicesSetting = Settings.Secure.getString(
            ctx.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false
        
        return enabledServicesSetting.split(":")
            .any { it.equals(expectedComponentName, ignoreCase = true) }
    }
    
    private fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        activity?.startActivity(intent)
    }
    
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        overlayChannel.setMethodCallHandler(null)
        accessibilityChannel.setMethodCallHandler(null)
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

