import 'package:flutter/material.dart';

class Preset {
  final String id;
  final IconData icon;
  final String name;
  final String description;
  final String category;

  const Preset({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.category,
  });
}

class PresetCategory {
  final String name;
  final List<Preset> presets;

  const PresetCategory({
    required this.name,
    required this.presets,
  });
}

