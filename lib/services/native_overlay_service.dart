import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class NativeOverlayService {
  static const MethodChannel _channel = MethodChannel('voicebubble/overlay');
  
  /// Check if overlay permission is granted
  static Future<bool> checkPermission() async {
    try {
      final bool? result = await _channel.invokeMethod('checkPermission');
      return result ?? false;
    } catch (e) {
      debugPrint('❌ Error checking overlay permission: $e');
      return false;
    }
  }
  
  /// Request overlay permission
  static Future<void> requestPermission() async {
    try {
      await _channel.invokeMethod('requestPermission');
    } catch (e) {
      debugPrint('❌ Error requesting overlay permission: $e');
    }
  }
  
  /// Show the native overlay bubble
  static Future<bool> showOverlay() async {
    try {
      debugPrint('🚀 Starting native overlay...');
      final bool? result = await _channel.invokeMethod('showOverlay');
      if (result == true) {
        debugPrint('✅ Native overlay shown successfully');
      } else {
        debugPrint('❌ Native overlay failed to show');
      }
      return result ?? false;
    } catch (e) {
      debugPrint('❌ Error showing overlay: $e');
      return false;
    }
  }
  
  /// Hide the native overlay bubble
  static Future<bool> hideOverlay() async {
    try {
      debugPrint('🛑 Hiding native overlay...');
      final bool? result = await _channel.invokeMethod('hideOverlay');
      return result ?? false;
    } catch (e) {
      debugPrint('❌ Error hiding overlay: $e');
      return false;
    }
  }
  
  /// Check if overlay is currently active
  static Future<bool> isActive() async {
    try {
      final bool? result = await _channel.invokeMethod('isActive');
      return result ?? false;
    } catch (e) {
      debugPrint('❌ Error checking overlay status: $e');
      return false;
    }
  }
}

