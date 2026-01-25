import 'package:flutter/material.dart';
import '../models/preset.dart';

class AppPresets {
  // Define all preset categories with their presets
  static final List<PresetCategory> categories = [
    PresetCategory(
      name: 'All Presets',
      presets: [
        // 1. MAGIC - Always first!
        Preset(
          id: 'magic',
          icon: Icons.auto_awesome,
          name: 'Magic',
          description: 'AI chooses the perfect format for you',
          category: 'All Presets',
        ),
        
        // 2. MESSAGES
        Preset(
          id: 'quick_reply',
          icon: Icons.flash_on,
          name: 'Quick Reply',
          description: 'Fast, concise response',
          category: 'All Presets',
        ),
        Preset(
          id: 'email_professional',
          icon: Icons.mail,
          name: 'Email – Professional',
          description: 'Clear professional email',
          category: 'All Presets',
        ),
        Preset(
          id: 'email_casual',
          icon: Icons.chat_bubble,
          name: 'Email – Casual',
          description: 'Friendly informal email',
          category: 'All Presets',
        ),
        
        // 3. SOCIAL MEDIA (Platform-specific & POWERFUL)
        Preset(
          id: 'x_thread',
          icon: Icons.format_list_bulleted,
          name: '𝕏 (Twitter) Thread',
          description: 'Engaging thread with hooks',
          category: 'All Presets',
        ),
        Preset(
          id: 'x_post',
          icon: Icons.chat,
          name: '𝕏 (Twitter) Post',
          description: 'Viral single post',
          category: 'All Presets',
        ),
        Preset(
          id: 'facebook_post',
          icon: Icons.public,
          name: 'Facebook Post',
          description: 'Engaging Facebook content',
          category: 'All Presets',
        ),
        Preset(
          id: 'instagram_caption',
          icon: Icons.camera_alt,
          name: 'Instagram Caption',
          description: 'Perfect caption with hashtags',
          category: 'All Presets',
        ),
        Preset(
          id: 'instagram_hook',
          icon: Icons.catching_pokemon,
          name: 'Instagram Hook',
          description: 'Attention-grabbing first line',
          category: 'All Presets',
        ),
        Preset(
          id: 'linkedin_post',
          icon: Icons.work,
          name: 'LinkedIn Post',
          description: 'Professional thought leadership',
          category: 'All Presets',
        ),
        
        // 4. TASKS & ORGANIZATION
        Preset(
          id: 'to_do',
          icon: Icons.check_circle,
          name: 'To-Do List',
          description: 'Convert thoughts to action items',
          category: 'All Presets',
        ),
        Preset(
          id: 'meeting_notes',
          icon: Icons.event_note,
          name: 'Meeting Notes',
          description: 'Structured meeting summary',
          category: 'All Presets',
        ),
        
        // 5. CREATIVE WRITING
        Preset(
          id: 'story_novel',
          icon: Icons.menu_book,
          name: 'Story / Novel Style',
          description: 'Transform into narrative prose',
          category: 'All Presets',
        ),
        Preset(
          id: 'poem',
          icon: Icons.auto_stories,
          name: 'Poem',
          description: 'Create poetic verse',
          category: 'All Presets',
        ),
        Preset(
          id: 'script_dialogue',
          icon: Icons.theater_comedy,
          name: 'Script / Dialogue',
          description: 'Movie or play script format',
          category: 'All Presets',
        ),
        
        // 6. REFINEMENT (These are also in refinement buttons)
        Preset(
          id: 'shorten',
          icon: Icons.content_cut,
          name: 'Shorten',
          description: 'Reduce length, keep meaning',
          category: 'All Presets',
        ),
        Preset(
          id: 'expand',
          icon: Icons.add_circle,
          name: 'Expand',
          description: 'Add detail and depth',
          category: 'All Presets',
        ),
        Preset(
          id: 'formal_business',
          icon: Icons.business_center,
          name: 'Make Formal',
          description: 'Professional business tone',
          category: 'All Presets',
        ),
        Preset(
          id: 'casual_friendly',
          icon: Icons.emoji_emotions,
          name: 'Make Casual',
          description: 'Friendly conversational tone',
          category: 'All Presets',
        ),
      ],
    ),
  ];

  // Quick access presets for the main screen (show top 4)
  static final List<Preset> quickPresets = [
    Preset(
      id: 'magic',
      icon: Icons.auto_awesome,
      name: 'Magic',
      description: 'AI chooses the perfect format',
      category: 'All Presets',
    ),
    Preset(
      id: 'quick_reply',
      icon: Icons.flash_on,
      name: 'Quick Reply',
      description: 'Fast, concise response',
      category: 'All Presets',
    ),
    Preset(
      id: 'instagram_caption',
      icon: Icons.camera_alt,
      name: 'Instagram Caption',
      description: 'Perfect caption with hashtags',
      category: 'All Presets',
    ),
    Preset(
      id: 'x_thread',
      icon: Icons.format_list_bulleted,
      name: '𝕏 Thread',
      description: 'Engaging Twitter thread',
      category: 'All Presets',
    ),
  ];

  // Get all presets as a flat list
  static List<Preset> get allPresets {
    return categories.expand((category) => category.presets).toList();
  }

  // Find preset by ID
  static Preset? findById(String id) {
    try {
      return allPresets.firstWhere((preset) => preset.id == id);
    } catch (e) {
      return null;
    }
  }
}

