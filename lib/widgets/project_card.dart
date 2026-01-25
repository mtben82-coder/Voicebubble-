import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  List<Color> _getGradientColors() {
    final gradients = [
      [const Color(0xFF3B82F6), const Color(0xFF2563EB)], // Blue
      [const Color(0xFF9333EA), const Color(0xFFEC4899)], // Purple-Pink
      [const Color(0xFF10B981), const Color(0xFF14B8A6)], // Green-Teal
      [const Color(0xFFF59E0B), const Color(0xFFF97316)], // Orange
      [const Color(0xFFEF4444), const Color(0xFFDC2626)], // Red
      [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)], // Violet
    ];

    final colorIndex = project.colorIndex ?? 0;
    return gradients[colorIndex % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientColors[0].withOpacity(0.15),
              gradientColors[1].withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: gradientColors[0].withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.folder,
                    color: textColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (project.description != null &&
                          project.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            project.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: secondaryTextColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.article,
                        size: 14,
                        color: gradientColors[0],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${project.itemCount} ${project.itemCount == 1 ? 'item' : 'items'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: gradientColors[0],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  project.formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
