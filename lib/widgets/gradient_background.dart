import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  
  const GradientBackground({
    super.key,
    required this.colors,
    required this.child,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}

// Predefined gradient backgrounds for convenience
class PurplePinkGradient extends StatelessWidget {
  final Widget child;
  
  const PurplePinkGradient({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFF0F172A),
        Color(0xFF581C87),
        Color(0xFF0F172A),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      child: child,
    );
  }
}

class BlueCyanGradient extends StatelessWidget {
  final Widget child;
  
  const BlueCyanGradient({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFF0F172A),
        Color(0xFF1E3A8A),
        Color(0xFF0F172A),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      child: child,
    );
  }
}

class EmeraldTealGradient extends StatelessWidget {
  final Widget child;
  
  const EmeraldTealGradient({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFF0F172A),
        Color(0xFF064E3B),
        Color(0xFF0F172A),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      child: child,
    );
  }
}

