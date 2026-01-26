import 'package:flutter/material.dart';
import '../models/preset.dart';

class PresetChip extends StatelessWidget {
  final Preset preset;
  final bool isLarge;

  const PresetChip({
    super.key,
    required this.preset,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = preset.color ?? const Color(0xFF3B82F6);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 10,
        vertical: isLarge ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isLarge ? 10 : 8),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            preset.icon,
            size: isLarge ? 16 : 14,
            color: color,
          ),
          SizedBox(width: isLarge ? 6 : 4),
          Text(
            preset.name,
            style: TextStyle(
              fontSize: isLarge ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
