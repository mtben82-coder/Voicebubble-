import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/outcome_type.dart';

class OutcomeChip extends StatelessWidget {
  final OutcomeType outcomeType;
  final bool isSelected;
  final VoidCallback onTap;

  const OutcomeChip({
    super.key,
    required this.outcomeType,
    required this.isSelected,
    required this.onTap,
  });

  List<Color> _getGradientColors() {
    switch (outcomeType) {
      case OutcomeType.message:
        return [const Color(0xFF3B82F6), const Color(0xFF2563EB)]; // Blue
      case OutcomeType.content:
        return [const Color(0xFF9333EA), const Color(0xFFEC4899)]; // Purple-Pink
      case OutcomeType.task:
        return [const Color(0xFF10B981), const Color(0xFF14B8A6)]; // Green-Teal
      case OutcomeType.idea:
        return [const Color(0xFFF59E0B), const Color(0xFFF97316)]; // Orange
      case OutcomeType.note:
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)]; // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : gradientColors[0].withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              outcomeType.emoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              outcomeType.displayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : gradientColors[0],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
