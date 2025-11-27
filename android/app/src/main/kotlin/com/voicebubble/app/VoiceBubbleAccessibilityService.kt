package com.voicebubble.app

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.ImageView
import android.view.View
import android.view.inputmethod.InputMethodManager

class VoiceBubbleAccessibilityService : AccessibilityService() {
    
    private var windowManager: WindowManager? = null
    private var bubbleView: View? = null
    private var isKeyboardVisible = false
    private var isBubbleShowing = false
    
    override fun onServiceConnected() {
        super.onServiceConnected()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }
    
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        
        // Detect keyboard visibility changes
        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                checkKeyboardVisibility()
            }
            AccessibilityEvent.TYPE_VIEW_FOCUSED -> {
                checkKeyboardVisibility()
            }
        }
    }
    
    private fun checkKeyboardVisibility() {
        // Check if keyboard is currently visible
        val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        val wasKeyboardVisible = isKeyboardVisible
        
        // Simple heuristic: if we can't determine, assume keyboard state hasn't changed
        // In practice, we'll show bubble when text fields are focused
        
        // For now, show bubble when service is active
        // A more robust implementation would track window changes
        if (!isBubbleShowing) {
            showBubble()
        }
    }
    
    private fun showBubble() {
        if (isBubbleShowing || bubbleView != null) return
        
        try {
            // Create bubble view
            bubbleView = createBubbleView()
            
            // Set up window parameters
            val layoutType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
            }
            
            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                layoutType,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
                PixelFormat.TRANSLUCENT
            )
            
            params.gravity = Gravity.TOP or Gravity.END
            params.x = 16
            params.y = 200
            
            // Add view to window manager
            windowManager?.addView(bubbleView, params)
            isBubbleShowing = true
            
            // Set up drag listener
            setupDragListener(params)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    private fun hideBubble() {
        try {
            if (bubbleView != null && isBubbleShowing) {
                windowManager?.removeView(bubbleView)
                bubbleView = null
                isBubbleShowing = false
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    private fun createBubbleView(): View {
        return ImageView(this).apply {
            try {
                setImageResource(android.R.drawable.ic_btn_speak_now)
                setPadding(32, 32, 32, 32)
                setBackgroundResource(android.R.drawable.btn_default)
                
                setOnClickListener {
                    try {
                        // Open main app when bubble is clicked
                        val intent = Intent(this@VoiceBubbleAccessibilityService, MainActivity::class.java).apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                            putExtra("open_recording", true)
                        }
                        startActivity(intent)
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
    
    private fun setupDragListener(params: WindowManager.LayoutParams) {
        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f
        var isMoved = false
        
        bubbleView?.setOnTouchListener { view, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    isMoved = false
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val deltaX = Math.abs(event.rawX - initialTouchX)
                    val deltaY = Math.abs(event.rawY - initialTouchY)
                    
                    if (deltaX > 10 || deltaY > 10) {
                        isMoved = true
                        params.x = initialX + (initialTouchX - event.rawX).toInt()
                        params.y = initialY + (event.rawY - initialTouchY).toInt()
                        try {
                            windowManager?.updateViewLayout(bubbleView, params)
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                    true
                }
                MotionEvent.ACTION_UP -> {
                    if (!isMoved) {
                        view.performClick()
                    }
                    false
                }
                else -> false
            }
        }
    }
    
    override fun onInterrupt() {
        hideBubble()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        hideBubble()
    }
}

