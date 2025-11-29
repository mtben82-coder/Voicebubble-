import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/preset.dart';

class AIService {
  // Backend URL - Change this based on your setup
  // PRODUCTION: Use your Railway deployment URL
  // LOCAL: Use your computer's local IP (find with 'ipconfig' or 'ifconfig')
  static const String _backendUrl = 'https://voicebubble-production.up.railway.app';
  
  // UNCOMMENT THIS FOR LOCAL DEVELOPMENT:
  // static const String _backendUrl = 'http://192.168.1.XXX:3000'; // Replace XXX with your local IP
  
  final Dio _dio = Dio();
  
  AIService() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }
  
  /// Convert audio file to text using backend Whisper API
  Future<String> transcribeAudio(File audioFile) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'audio.wav',
        ),
      });
      
      final response = await _dio.post(
        '$_backendUrl/api/transcribe',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      return response.data['text'] ?? '';
    } catch (e) {
      print('Transcription error: $e');
      throw Exception('Failed to transcribe audio: $e');
    }
  }
  
  /// Rewrite text using backend GPT-4 mini API
  Future<String> rewriteText(String text, Preset preset) async {
    try {
      // Use batch endpoint (non-streaming) for simplicity
      final response = await _dio.post(
        '$_backendUrl/api/rewrite/batch',
        data: {
          'text': text,
          'presetId': preset.id,
        },
      );
      
      return response.data['text'] ?? '';
    } catch (e) {
      print('Rewrite error: $e');
      throw Exception('Failed to rewrite text: $e');
    }
  }
}

