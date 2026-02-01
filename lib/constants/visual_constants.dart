import 'package:flutter/material.dart';

enum BackgroundType {
  solidColor,
  gradient,
  texture,
  illustrated,
}

class Background {
  final String id;
  final String name;
  final BackgroundType type;
  final Color? primaryColor;
  final Color? secondaryColor;
  final List<Color>? gradientColors;
  final String? assetPath; // For texture/illustrated backgrounds

  const Background({
    required this.id,
    required this.name,
    required this.type,
    this.primaryColor,
    this.secondaryColor,
    this.gradientColors,
    this.assetPath,
  });

  Widget buildBackground(BuildContext context) {
    switch (type) {
      case BackgroundType.solidColor:
        return Container(color: primaryColor);
      
      case BackgroundType.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ?? [primaryColor!, secondaryColor!],
            ),
          ),
        );
      
      case BackgroundType.texture:
        // For simple patterns, use color with opacity
        return Container(
          decoration: BoxDecoration(
            color: primaryColor,
            backgroundBlendMode: BlendMode.overlay,
          ),
        );
      
      case BackgroundType.illustrated:
        // Load from assets if available, otherwise use gradient fallback
        if (assetPath != null) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(assetPath!),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        // Fallback to gradient
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ?? [primaryColor!, secondaryColor!],
            ),
          ),
        );
    }
  }
}

class VisualConstants {
  // SOLID COLORS - Pastels
  static const Background colorWhite = Background(
    id: 'color_white',
    name: 'White',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFFFFFFF),
  );

  static const Background colorLavender = Background(
    id: 'color_lavender',
    name: 'Lavender',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFE6E6FA),
  );

  static const Background colorMint = Background(
    id: 'color_mint',
    name: 'Mint',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFB5EAD7),
  );

  static const Background colorPeach = Background(
    id: 'color_peach',
    name: 'Peach',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFFFDAB9),
  );

  static const Background colorSky = Background(
    id: 'color_sky',
    name: 'Sky Blue',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFADD8E6),
  );

  static const Background colorRose = Background(
    id: 'color_rose',
    name: 'Rose',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFFFB6C1),
  );

  static const Background colorLemon = Background(
    id: 'color_lemon',
    name: 'Lemon',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFFFFACD),
  );

  // SOLID COLORS - Vibrant
  static const Background colorBlue = Background(
    id: 'color_blue',
    name: 'Blue',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFF3B82F6),
  );

  static const Background colorPurple = Background(
    id: 'color_purple',
    name: 'Purple',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFF8B5CF6),
  );

  static const Background colorGreen = Background(
    id: 'color_green',
    name: 'Green',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFF10B981),
  );

  static const Background colorRed = Background(
    id: 'color_red',
    name: 'Red',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFEF4444),
  );

  static const Background colorOrange = Background(
    id: 'color_orange',
    name: 'Orange',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFFF97316),
  );

  // SOLID COLORS - Dark/Light
  static const Background colorDark = Background(
    id: 'color_dark',
    name: 'Dark',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFF1A1A1A),
  );

  static const Background colorGray = Background(
    id: 'color_gray',
    name: 'Gray',
    type: BackgroundType.solidColor,
    primaryColor: Color(0xFF6B7280),
  );

  // GRADIENTS - Vibrant
  static const Background gradientSunset = Background(
    id: 'gradient_sunset',
    name: 'Sunset',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFA500), Color(0xFFFFD93D)],
  );

  static const Background gradientOcean = Background(
    id: 'gradient_ocean',
    name: 'Ocean',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
  );

  static const Background gradientPurple = Background(
    id: 'gradient_purple',
    name: 'Purple Dream',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );

  static const Background gradientPink = Background(
    id: 'gradient_pink',
    name: 'Pink Bliss',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFFFF6B9D), Color(0xFFC33764)],
  );

  static const Background gradientNeon = Background(
    id: 'gradient_neon',
    name: 'Neon Glow',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFF00F260), Color(0xFF0575E6)],
  );

  // GRADIENTS - Soft/Pastel
  static const Background gradientPeach = Background(
    id: 'gradient_peach',
    name: 'Soft Peach',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFFFFE5E5), Color(0xFFFFCCCC)],
  );

  static const Background gradientLavender = Background(
    id: 'gradient_lavender',
    name: 'Soft Lavender',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFFE6E6FA), Color(0xFFD8BFD8)],
  );

  static const Background gradientMint = Background(
    id: 'gradient_mint',
    name: 'Soft Mint',
    type: BackgroundType.gradient,
    gradientColors: [Color(0xFFB5EAD7), Color(0xFF98D8C8)],
  );

  // TEXTURES - Paper
  static const Background textureLined = Background(
    id: 'texture_lined',
    name: 'Lined Paper',
    type: BackgroundType.texture,
    primaryColor: Color(0xFFFFFDF7),
  );

  static const Background textureGrid = Background(
    id: 'texture_grid',
    name: 'Grid Paper',
    type: BackgroundType.texture,
    primaryColor: Color(0xFFF5F5F5),
  );

  static const Background textureDots = Background(
    id: 'texture_dots',
    name: 'Dot Grid',
    type: BackgroundType.texture,
    primaryColor: Color(0xFFFAFAFA),
  );

  static const Background textureVintage = Background(
    id: 'texture_vintage',
    name: 'Vintage Paper',
    type: BackgroundType.texture,
    primaryColor: Color(0xFFFFF8DC),
  );

  // ILLUSTRATED - Nature
  static const Background illustratedMountain = Background(
    id: 'mountain',
    name: 'Mountain',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/mountain.png',
    gradientColors: [Color(0xFF4A5568), Color(0xFF718096)], // Fallback
  );

  static const Background illustratedOcean = Background(
    id: 'ocean',
    name: 'Ocean',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/ocean.png',
    gradientColors: [Color(0xFF3B82F6), Color(0xFF06B6D4)], // Fallback
  );

  static const Background illustratedForest = Background(
    id: 'forest',
    name: 'Forest',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/forest.png',
    gradientColors: [Color(0xFF059669), Color(0xFF10B981)], // Fallback
  );

  static const Background illustratedCity = Background(
    id: 'city',
    name: 'City',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/city.png',
    gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Fallback
  );

  static const Background illustratedSpace = Background(
    id: 'space',
    name: 'Space',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/space.png',
    gradientColors: [Color(0xFF1E1B4B), Color(0xFF312E81)], // Fallback
  );

  // ILLUSTRATED - Abstract
  static const Background illustratedWaves = Background(
    id: 'waves',
    name: 'Waves',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/waves.png',
    gradientColors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)], // Fallback
  );

  static const Background illustratedCircles = Background(
    id: 'circles',
    name: 'Circles',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/circles.png',
    gradientColors: [Color(0xFFF472B6), Color(0xFFEC4899)], // Fallback
  );

  static const Background illustratedGeometric = Background(
    id: 'geometric',
    name: 'Geometric',
    type: BackgroundType.illustrated,
    assetPath: 'assets/backgrounds/geometric.png',
    gradientColors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)], // Fallback
  );

  // All backgrounds organized
  static const List<Background> allBackgrounds = [
    // Solid - Pastels
    colorWhite,
    colorLavender,
    colorMint,
    colorPeach,
    colorSky,
    colorRose,
    colorLemon,
    // Solid - Vibrant
    colorBlue,
    colorPurple,
    colorGreen,
    colorRed,
    colorOrange,
    // Solid - Dark/Light
    colorDark,
    colorGray,
    // Gradients - Vibrant
    gradientSunset,
    gradientOcean,
    gradientPurple,
    gradientPink,
    gradientNeon,
    // Gradients - Soft
    gradientPeach,
    gradientLavender,
    gradientMint,
    // Textures
    textureLined,
    textureGrid,
    textureDots,
    textureVintage,
    // Illustrated - Nature
    illustratedMountain,
    illustratedOcean,
    illustratedForest,
    illustratedCity,
    illustratedSpace,
    // Illustrated - Abstract
    illustratedWaves,
    illustratedCircles,
    illustratedGeometric,
  ];

  // Get backgrounds by type
  static List<Background> getByType(BackgroundType type) {
    return allBackgrounds.where((bg) => bg.type == type).toList();
  }

  // Find background by ID
  static Background? findById(String id) {
    try {
      return allBackgrounds.firstWhere((bg) => bg.id == id);
    } catch (e) {
      return null;
    }
  }
}
