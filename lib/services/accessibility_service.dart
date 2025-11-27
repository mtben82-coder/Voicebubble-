import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AccessibilityService {
  static const MethodChannel _channel = MethodChannel('voicebubble/accessibility');
  
  /// Check if accessibility service is enabled
  static Future<bool> isEnabled() async {
    try {
      final bool? result = await _channel.invokeMethod('isEnabled');
      return result ?? false;
    } catch (e) {
      debugPrint('❌ Error checking accessibility service: $e');
      return false;
    }
  }
  
  /// Open accessibility settings to enable the service
  static Future<void> openSettings() async {
    try {
      await _channel.invokeMethod('openSettings');
    } catch (e) {
      debugPrint('❌ Error opening accessibility settings: $e');
    }
  }
}

