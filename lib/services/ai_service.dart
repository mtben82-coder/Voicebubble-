import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/preset.dart';

class AIService {
  static const String _openaiApiUrl = 'https://api.openai.com/v1';
  final Dio _dio = Dio();
  
  String get _apiKey {
    // Try to get from environment variable first (for Railway deployment)
    final envKey = Platform.environment['OPENAI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }
    
    // Fallback to .env file (for local development)
    return dotenv.env['OPENAI_API_KEY'] ?? '';
  }
  
  AIService() {
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }
  
  /// Convert audio file to text using Whisper API
  Future<String> transcribeAudio(File audioFile) async {
    if (_apiKey.isEmpty) {
      // Return mock transcription for development
      return "I'm stuck in traffic but I'm finishing the report right now and I'll be there in like 10 minutes";
    }
    
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'audio.wav',
        ),
        'model': 'whisper-1',
        'language': 'en',
      });
      
      final response = await _dio.post(
        '$_openaiApiUrl/audio/transcriptions',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      return response.data['text'] ?? '';
    } catch (e) {
      throw Exception('Failed to transcribe audio: $e');
    }
  }
  
  /// Rewrite text using GPT-4o-mini based on preset
  Future<String> rewriteText(String text, Preset preset) async {
    if (_apiKey.isEmpty) {
      // Return mock rewritten text for development
      return _getMockRewrite(text, preset);
    }
    
    try {
      final systemPrompt = _getSystemPrompt(preset);
      
      final response = await _dio.post(
        '$_openaiApiUrl/chat/completions',
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': text},
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );
      
      final content = response.data['choices'][0]['message']['content'];
      return content.trim();
    } catch (e) {
      throw Exception('Failed to rewrite text: $e');
    }
  }
  
  String _getSystemPrompt(Preset preset) {
    final prompts = {
      // General
      'magic': 'You are an expert writing assistant. Analyze the input and rewrite it in the most appropriate style and format. Choose the best way to present the information clearly and effectively.',
      'slightly': 'You are a text editor. Clean up the input text by fixing grammar, spelling, and minor clarity issues. Keep the original tone and style as much as possible.',
      'significantly': 'You are a professional writer. Significantly revise the input text for better clarity, structure, and understanding. Improve flow and readability while maintaining the core message.',
      
      // Text Editing
      'structured': 'You are a content organizer. Transform the input into a well-structured format using bullet points, numbered lists, and clear headings where appropriate.',
      'shorter': 'You are a concise writer. Reduce the length of the input text while preserving all essential meaning and information. Be brief but complete.',
      'list': 'You are a list maker. Convert the input into a clear, organized list format (bullet points or numbered list) suitable for tasks, shopping, or notes.',
      
      // Content Creation
      'x-post': 'You are a social media expert. Transform the input into an engaging, concise tweet (under 280 characters). Make it punchy, interesting, and shareable.',
      'x-thread': 'You are a Twitter thread creator. Transform the input into a series of connected tweets. Number each tweet (1/n, 2/n, etc.) and keep each under 280 characters.',
      'facebook': 'You are a social media specialist. Create an interesting, engaging Facebook post from the input. Make it conversational and suitable for social sharing.',
      'linkedin': 'You are a professional content creator. Write a polished, professional LinkedIn post. Include relevant insights and maintain a business-appropriate tone.',
      'instagram': 'You are an Instagram content creator. Write a captivating Instagram caption from the input. Make it engaging, use line breaks for readability, and consider emoji use.',
      'video-script': 'You are a YouTube scriptwriter. Transform the input into a detailed video script with clear sections: intro, main content, and outro. Include speaking cues.',
      'short-video': 'You are a short-form video creator. Write a punchy 15-60 second script for TikTok, Instagram Reels, or YouTube Shorts. Make it engaging and quick.',
      'newsletter': 'You are an email newsletter writer. Transform the input into a professional newsletter section with an engaging subject line and well-structured content.',
      'outline': 'You are an outline creator. Create a structured outline from the input using headings, subheadings, and key points. Make it ready for future expansion.',
      
      // Journaling
      'journal': 'You are a journal writing assistant. Transform the input into a well-formatted journal entry with clear thoughts, reflections, and readable structure.',
      'gratitude': 'You are a gratitude journal specialist. Transform the input into a heartfelt gratitude journal entry, highlighting positive aspects and blessings.',
      
      // Emails
      'casual-email': 'You are an informal email writer. Compose a friendly, casual email from the input. Keep it warm and conversational while remaining appropriate.',
      'formal-email': 'You are a professional email writer. Compose a clear, formal, professional email with proper greeting, body, and closing. Be polite and concise.',
      
      // Summary
      'short-summary': 'You are a summarization expert. Create a brief summary highlighting only the key points. Be concise and capture the essence.',
      'detailed-summary': 'You are a thorough summarizer. Create a comprehensive summary that covers all important points in detail while remaining organized and clear.',
      'meeting-takeaways': 'You are a meeting notes specialist. Transform the input into clear meeting takeaways with key points, decisions, and action items.',
      
      // Writing Styles
      'business': 'You are a business communications expert. Rewrite the input in a professional business style that communicates effectively and appropriately.',
      'formal': 'You are a formal writing specialist. Transform the input into highly formal language suitable for official or governmental communication.',
      'casual': 'You are a casual writer. Rewrite the input in an informal, relaxed style without strict formalities. Keep it friendly and easy-going.',
      'friendly': 'You are a friendly communicator. Rewrite the input as if writing to a close friend. Be warm, personal, and conversational.',
      'clear-concise': 'You are a clarity expert. Rewrite the input to be crystal clear and concise. Remove unnecessary words and get straight to the point.',
      
      // Holiday Greetings
      'funny': 'You are a humor writer. Transform the input into something funny and lighthearted. Add wit and playfulness while keeping it appropriate.',
      'warm': 'You are a warm, friendly writer. Transform the input into something genuinely warm and friendly. Make it feel personal and heartfelt.',
      'simple-professional': 'You are a professional greeting writer. Create a simple, professional message that is polite and appropriate for business contexts.',
    };
    
    return prompts[preset.id] ?? prompts['magic']!;
  }
  
  String _getMockRewrite(String text, Preset preset) {
    // Mock responses for development/testing
    final mocks = {
      'formal-email': 'Dear Recipient,\n\nI apologize for the delay in my arrival. Due to unexpected traffic conditions, I am currently en route and anticipate arriving approximately 10 minutes behind schedule. I am concurrently completing the required report and will have it prepared upon my arrival.\n\nThank you for your understanding.\n\nBest regards',
      'casual': 'Hey! Running a bit late due to traffic, but almost done with the report. Should be there in about 10 minutes!',
      'list': '• Stuck in traffic\n• Finishing the report\n• Arriving in 10 minutes',
      'magic': 'I apologize for the delay. Due to unexpected traffic, I will arrive approximately 10 minutes behind schedule. I am currently completing the report and will have it ready upon arrival.',
    };
    
    return mocks[preset.id] ?? 
           'I apologize for the delay. Due to unexpected traffic, I will arrive approximately 10 minutes behind schedule. I am currently completing the report and will have it ready upon arrival.';
  }
}

