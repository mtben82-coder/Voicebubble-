package com.voicebubble.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity

class OverlayService : Service() {
    
    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var isOverlayVisible = false
    
    companion object {
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "VoiceBubbleOverlay"
        
        fun start(context: Context) {
            val intent = Intent(context, OverlayService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
        
        fun stop(context: Context) {
            val intent = Intent(context, OverlayService::class.java)
            context.stopService(intent)
        }
    }
    
    override fun onCreate() {
        super.onCreate()
        
        // Create notification channel
        createNotificationChannel()
        
        // Start foreground service
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        // Initialize window manager
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        
        // Create and show overlay
        createOverlay()
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "VoiceBubble Overlay",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows floating bubble for voice input"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE
        )
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("VoiceBubble Active")
            .setContentText("Tap to open app")
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
    
    private fun createOverlay() {
        // Create overlay view
        overlayView = createBubbleView()
        
        // Set up window parameters
        val params = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        }
        
        params.gravity = Gravity.TOP or Gravity.END
        params.x = 16
        params.y = 100
        
        // Add view to window manager
        windowManager?.addView(overlayView, params)
        isOverlayVisible = true
        
        // Set up touch listener for dragging
        setupDragListener(params)
    }
    
    private fun createBubbleView(): View {
        val inflater = getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        
        // Create a simple bubble view programmatically
        val bubbleView = ImageView(this).apply {
            setImageResource(android.R.drawable.ic_btn_speak_now)
            setPadding(20, 20, 20, 20)
            setBackgroundResource(android.R.drawable.btn_default)
            
            setOnClickListener {
                // Open main app when bubble is clicked
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                    putExtra("open_recording", true)
                }
                startActivity(intent)
            }
        }
        
        return bubbleView
    }
    
    private fun setupDragListener(params: WindowManager.LayoutParams) {
        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f
        
        overlayView?.setOnTouchListener { view, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = initialX + (initialTouchX - event.rawX).toInt()
                    params.y = initialY + (event.rawY - initialTouchY).toInt()
                    windowManager?.updateViewLayout(overlayView, params)
                    true
                }
                else -> false
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        
        // Remove overlay view
        if (overlayView != null) {
            windowManager?.removeView(overlayView)
            overlayView = null
            isOverlayVisible = false
        }
    }
    
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}

